`include "blinky_led.v"

module blinky_led_tb;
  reg clk;
  wire led;

  blinky_led bl0(.clk(clk),
                 .led(led));
  initial begin
    clk = 0;
    $monitor("%0t: clk=%d, led=%d", $time, clk, led);
  end

  initial #280 $finish;

  always #5 clk = ~clk;

endmodule