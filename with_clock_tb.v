`include "with_clock.v"

module with_clock_tb;
  reg clk;
  reg reset;
  wire [7:0] out;

  with_clock wc0(.clk(clk), 
                 .reset(reset),
                 .out(out));

  initial begin
    clk = 0;
    reset = 0;
    $monitor("%0t: clock=%d, out=%d", $time, clk, out);
  end

  initial begin
    #8 reset = 1;
    #50 $finish;
  end

  always #5 clk = ~clk;

endmodule