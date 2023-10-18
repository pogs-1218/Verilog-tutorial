`default_nettype none
module led(i_sw, o_led);
  input wire i_sw;
  output wire o_led;

  assign o_led = i_sw;

  initial begin
    $display("Hello world!");
    $finish;
  end
endmodule
