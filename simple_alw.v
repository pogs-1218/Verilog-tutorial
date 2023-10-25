// All signals used in a procedural block(initial, always) should be declared as type reg.
module simple_alw;
  reg clk;
  reg r;
  reg q;

  initial begin
    $dumpfile("simple_alw.vcd");
    $dumpvars(0, simple_alw);
    r = 0;
    clk = 0;
    #100 $finish;
  end

  always @ (posedge clk) begin
    if (r)
      q = 0;
    else
      q = 1;
  end

  always #10 r = ~r;

  always #5 clk = ~clk;

endmodule