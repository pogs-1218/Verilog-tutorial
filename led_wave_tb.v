`include "led_wave.v"

module led_wave_tb;
  reg clk;
  wire [7:0] led;

  led_wave lw0(.clk(clk),
               .led(led));

  initial begin
    $dumpfile("led_wave.vcd");
    $dumpvars(0, led_wave_tb);
    clk = 0;

    $monitor("%2t: %b - %b", $time, clk, led);
  end

  initial #100 $finish;

  always #5 clk = ~clk;

endmodule
