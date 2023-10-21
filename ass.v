module ass(input [3:0] x,
           input y,
           output [4:0] z);
  assign z = {x, y};
  // assign z = {3{y}};

  // assign z[3:1] = {x, y};
  // assign z[4:1] = {x, y};
  // assign z[4] = 1;

  // assign z[3:0] = x;
  // assign z[4] = y;

  // assign z = {x[1:0], y};

endmodule
