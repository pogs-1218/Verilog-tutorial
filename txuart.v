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
              output out);
  localparam IDLE = 2'b00,
             START = 2'b01,
             DATA = 2'b10,
             STOP = 2'b11;
  wire busy;
  reg [1:0] state;
  reg [8:0] buffer;
  reg [2:0] index;

  initial {state, buffer, index} = {IDLE, 9'h1ff, 3'd0};
  always @ (posedge clk) begin
    $display("uart busy? : %b", busy);
    $display("uart| bus: %b", databus);
    $display("uart|[%b] index: %d , buffer: %b", state, index, buffer);
    if (reset && !busy) begin
      state <= START;
    end

    case(state)
    IDLE: begin
      {buffer, index} <= { 9'h1ff, 3'd0 };
    end

    START: begin
      buffer <= {databus, 1'b0};
      index <= index + 1'b1;
      state <= DATA;
    end

    DATA: begin
      if (index >= 7)
        state <= STOP;
      else begin
        buffer <= { 1'b1, buffer[8:1] };
      end
    end

    STOP: begin
      state <= IDLE;
    end

    default: state <= IDLE;
    endcase
  end

  // initial state: false
  assign busy = (state != IDLE);
  assign out = buffer[0];

endmodule
