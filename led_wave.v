module led_wave(input clk,
                output reg [7:0] led); 
  initial led = 1'b1;
  always @ (posedge clk) begin
    // left shift
    led <= {led[6:0], led[7]};
  end

endmodule
