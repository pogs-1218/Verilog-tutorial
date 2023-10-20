module addbit(
  a,  // first input
  b,  // second input
  ci, // carry input
  sum, // sum output
  co   // carry output
);
input wire a;
input wire b;
input wire ci;

output wire sum;
output wire co;

assign {co, sum} = a + b + ci;

endmodule
