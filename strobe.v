module strobe(input clk,
              output led);
  reg [26:0] counter;

  always @ (posedge clk)
    counter <= counter + 1'b1;
  /*
    counter[26:24]
    ...
    100..., 101..., 111...,
    000..., 001..., 010..., 011..., 100...,
    Turn led on every 8th counter?
  */
  assign led = &counter[26:24];

endmodule
