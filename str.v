module str;
reg [8*4:1] str1;
reg [8*5:1] str2;
reg [8*6:1] str3;

initial begin
  str1 = "hello";
  str2 = "hello";
  str3 = "hello";
  $display("str1:%s", str1);
  $display("str2:%s", str2);
  $display("str3:%s", str3);
end

endmodule