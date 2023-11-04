/**
 Key concepts
 1. State machine based.
  idle: start bit is 0.
 2. Shift register
  input ports is 8-bit net. 
 3. clock & baudrate control
 4. testbench in cpp
  implement txuart wrapper to send a temp message.
  implement uart rx part.

  States
 idle: reset = 0
 start:
 data:
 stop:
*/
`default_nettype none

module txuart(input clk,
              input reset,
              input [7:0] databus,
              output reg busy,
              output out);
  // default : 100MHZ and 115,200bps = 
  // # of pulses / 1 bit
  parameter CLOCKS_PER_BAUD = 868;

  localparam IDLE = 2'b00,
             START = 2'b01,
             DATA = 2'b10,
             STOP = 2'b11;
  reg [1:0] state;
  reg [8:0] buffer;
  reg [2:0] index;

  reg baud_stb;
  reg [31:0] baud_counter;

  initial {state, buffer, index, busy} = {IDLE, 9'h1ff, 3'd0, 1'b0};
  always @ (posedge clk) begin
    // $display("uart busy? : %b", busy);
    // $display("uart| bus: %b", databus);
    // $display("uart|[%b] index: %d , buffer: %b", state, index, buffer);
    // $display("uart| baud counter: %0d , stb: %b", baud_counter, baud_stb);
    if (reset && !busy) begin
      $display("txuart start");
      state <= START;
      busy <= 1'b1;
    end

    case(state)
    IDLE: begin
      {buffer, index} <= { 9'h1ff, 3'd0 };
      busy <= 1'b0;
    end

    START: begin
      buffer <= {databus, 1'b0};
      state <= DATA;
    end

    DATA: begin
      // $display("[stb: %b] buffer: 0x%0h(%b)",baud_stb, buffer, buffer);
      if (index >= 7)
        state <= STOP;
      else if (baud_stb) begin
        $display(" buffer: 0x%0h(%b)",buffer, buffer);
        buffer <= { 1'b1, buffer[8:1] };
        index <= index + 1'b1;
      end
    end

    STOP: begin
      state <= IDLE;
    end

    default: state <= IDLE;
    endcase
  end

  assign out = buffer[0];

  // baudrate control
  initial baud_counter = 32'd0;
  always @ (posedge clk) begin
    if (baud_counter == CLOCKS_PER_BAUD) begin
      baud_stb <= 1'b1;
      baud_counter <= 32'd0;
    end
    else if (baud_counter < CLOCKS_PER_BAUD) begin
      baud_stb <= 1'b0;
      baud_counter <= baud_counter + 1'b1;
    end
  end

endmodule
