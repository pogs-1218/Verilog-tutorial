module blinky_led(input wire clk,
                  output wire led);
  parameter WIDTH = 4;
  reg [WIDTH-1:0] counter;
  initial counter = 0;
  always @ (posedge clk) begin
    /*
      4-bits counter with increment by one bit.
      0001, 
      0010, 0011, 
      0100, 0101, 0111,
      1000, 1001, 1010, 1011, 1100, 1101, 1111,
      (7th clock)

      5-bits counter with increment by one bit.
      00001, 
      00010, 00011, 
      00100, 00101, 00110, 00111, 
      01000, 01001, 01010, 01011, 01100, 01101, 01110, 01111,
      10000,
      (15th clock)

      conclusion: on every 2^N-1th clock
    */
    counter <= counter + 1'b1;
  end
  assign led = counter[WIDTH-1];

endmodule
