`include "ass.v"

module ass_tb;
  reg [3:0] x;
  reg y;
  wire [4:0] z;

  ass a0(.x(x),
         .y(y),
         .z(z));

  initial begin
    x = 4'hC;  // 1100
    y = 1'h1;   // 1

    $display("%b", z);
  end

endmodule