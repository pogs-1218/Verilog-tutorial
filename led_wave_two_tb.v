`include "led_wave_two.v"

module led_wave_two_tb;
  reg clk;
  wire [7:0] led;

  led_wave_two lw0(.clk(clk),
                   .led(led));

  initial begin
    $dumpfile("led_wave_two.vcd");
    $dumpvars(0, led_wave_two_tb);
    clk = 0;

    $monitor("%3t: %b - %b", $time, clk, led);
  end

  initial #200 $finish;

  always #5 clk = ~clk;

endmodule
