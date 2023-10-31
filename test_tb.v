`include "test.v"

`default_nettype none

module test_tb;
  reg clk;
  reg reset;
  reg [7:0] data;

  wire o_data;

  initial begin
    clk = 0;
    reset = 0;
    data = 8'h68;
  end

  initial begin
    #5 reset = 1;
    #25 $finish;
  end

  test t0(.clk(clk), .reset(reset), .data(data), .o_data(o_data));

  always #5 clk = ~clk;

endmodule