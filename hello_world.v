module hello_world;
initial begin
  $dumpfile("hello_world.vcd");
  $dumpvars(0, hello_world);
  $display("hello world");
  #5 $display("hi?");
  $finish;
end
endmodule
