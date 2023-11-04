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

Goal: Send a string on every second.
      Redirect out wire to testbench.
      If status is true, stop it.
*/
module txuart_wrapper(input clk,
                      output reg status,
                      output out);
  // default: 100Mhz
  // Clcck rate (Frequency) = # of pulses / 1 sec
  parameter CLOCK_RATE_HZ = 100_000_000;
  // default: 115,200bps
  // bps = # of bits / 1 sec
  parameter BAUDRATE = 115_200;

  // localparam SENDIDLE = 0,
  //            SENDSTART = 1,
  //            SENDEND = 2;
  wire busy;

  // for timer
  reg tx_start;
  reg [31:0] counter;

  // Send each character through this 8-bit bus
  reg [7:0] input_bus;

  // 56-bits, [55:0]
  reg [8*7-1:0] str;
  reg [2:0] index;

  // reg [2:0] state;

  initial status = 1'b0; // temp
  initial index = 0;
  initial str = "hello\r\n";
  initial input_bus = 8'd0;
  always @ (posedge clk) begin
    if (tx_start && !busy) begin
      $display("wrapper start");
      input_bus <= str[8*(7-index)-1 -: 8];
      index <= index + 1'b1;
      status <= 1'b1;
    end
  end

  initial tx_start = 1'b0;
  initial counter = 32'd0;
  always @ (posedge clk) begin
    if(counter == CLOCK_RATE_HZ - 1) begin
      $display("wrapper| tx start!");
      tx_start <= 1'b1;
      counter <= 32'd0;
    end
    else begin
      tx_start <= 1'b0;
      counter <= counter + 1'b1;
    end
  end

  // assign status = (index == 7);

  txuart #(.CLOCKS_PER_BAUD(CLOCK_RATE_HZ/BAUDRATE))
  tu0(.clk(clk),
      .reset(tx_start),
      .databus(input_bus),
      .busy(busy),
      .out(out));
 
endmodule;
