module with_clock(input clk,
                  input reset,
                  output reg[7:0] out);
  always @ (posedge clk) begin
    if(!reset)
      out = 0;
    else begin
      out <= 5;  // ignored !!
      out <= out + 1'b1;
    end
  end 

endmodule
