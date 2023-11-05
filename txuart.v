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
`timescale 1ns/10ps
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
  reg [3:0] index;

  reg tmp;
  reg baud_stb;
  reg [31:0] baud_counter;

  initial {state, buffer, index, busy} = {IDLE, 9'h1ff, 4'd0, 1'b0};

  // baudrate control
  initial baud_counter = 32'd0;
  initial baud_stb = 1'b0;
  initial tmp = 1'b0;
  always @ (posedge clk) begin
    if (tmp) begin
      if (baud_counter >= CLOCKS_PER_BAUD - 1) begin
        baud_stb <= 1'b1;
        baud_counter <= 32'd0;
      end
      else begin
        baud_stb <= 1'b0;
        baud_counter <= baud_counter + 1'b1;
      end
    end
  end

  always @ (posedge clk) begin
    // tick: 100 000 000
    if (reset && !busy) begin
      $display("%0t start---------", $time);
      state <= START;
      busy <= 1'b1;
      tmp <= 1'b1;
    end

    case(state)
    IDLE: begin
      {buffer, index} <= { 9'h1ff, 4'd0 };
      busy <= 1'b0;
    end

    // tick: 100 000 001
    START: begin
      $display("%0t | txuart start", $time);
      buffer <= {databus, 1'b0};
      state <= DATA;
    end

    // tick: 100 000 002
    // 2 -> 870 -> 1738 -> 2606
    // s    d[0]   d[1]   d[2]
    //  435   1304    2172
    DATA: begin
      if (index >= 9)
        state <= STOP;
      else if (baud_stb) begin
        $display("%0t | buffer: 0x%0h(%b)", $time, buffer, buffer);
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

endmodule
