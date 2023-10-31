`include "txuart.v"
`default_nettype none

/*
 Send a string to txuart.
 "hello\r\n"
  : 7 bytes = 28-bits

txuart wrapper
wrapper -> txuart -> cpp testbench
      (par)    (serial)

h : 0110_1000 (0x68)
e : 0110_0101 (0x65)
l : 0110_1100 (0x6c)
l : 0110_1100 (0x6c)
o : 0110_1111 (0x6f)
\r : 0000_1101 (0x0d)
\n : 0000_1010 (0x0a)
*/
module txuart_wrapper(input clk,
                      input reset,
                      output out);
  localparam SENDIDLE = 0,
             SENDSTART = 1,
             SENDEND = 2;
  wire busy;

  // Send each character through this 8-bit bus
  reg [7:0] input_bus;

  // 56-bits, [55:0]
  reg [8*7-1:0] str;
  reg [2:0] index;

  reg [2:0] state;

  txuart tu0(.clk(clk),
             .reset(reset),
             .databus(input_bus),
             .out(out));

  /**
  table
    tick  busy reset  wrapper.state   uart.state   wrapper.input   uart.data
     5     0     1      SENDIDLE        IDLE           0           9'h1ff
     6     1     1      SENDSTART       START         0x68         0x68
     7 .   1 .   1 .    SENDSTART       DATA          0x65         
     8 .   1 .   1 .                                                 
  */
  
  initial index = 0;
  initial state = SENDIDLE;
  initial str = "hello\r\n";
  initial input_bus = 8'd0;
  always @ (posedge clk) begin
    $display("wrapper|[%b] [i:%0d] str: 0x%h | input: 0x%h",state, index, str[8*(7-index)-1 -: 8], input_bus);
    if (reset && !busy) begin
      input_bus <= str[8*(7-index)-1 -: 8];
      index <= index + 1'b1;
      state <= SENDSTART;
    end

    case(state)
    SENDSTART: begin
      if (index >= 7)
        state <= SENDEND;
      else begin
        input_bus <= str[8*(7-index)-1 -: 8];
        index <= index + 1'b1;
      end
    end
    SENDEND: begin
      state <= SENDIDLE;
    end
    default: state <= SENDIDLE;
    endcase
  end

  assign busy = (state != SENDIDLE);

endmodule;

