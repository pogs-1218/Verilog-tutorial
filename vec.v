module vec;
  reg [31:0] data;
  integer i;

  initial begin
    // data = 3'b111;
    // $display("data: %b", data);
    data = 32'hFACE_CAFE;
    // data[32:24] = data[24 +: 8]
    // data[24:16] = data[16 +: 8]
    for(i = 4; i > 0; i--) begin
      $display("data[8*%0d -: 8] = 0x%0h", i, data[8*i-1 -: 8]);
      // $display("%d", i);
    end
    // 31 = 8 * 4 -1
    $display("1: 0x%0h", data[31 -: 8]);
    // 23 = 8 * 3 - 1
    $display("2: 0x%0h", data[23 -: 8]);
    // 15 = 8 * 2 - 1
    $display("3: 0x%0h", data[15 -: 8]);
    // 7 = 8 * 1 - 1
    $display("4: 0x%0h", data[7 -: 8]);

    $display("data[7:0]      = 0x%0h", data[7:0]);
    $display("data[15:8]     = 0x%0h", data[15:8]);
    $display("data[23:16]    = 0x%0h", data[23:16]);
    $display("data[31:24]    = 0x%0h", data[31:24]);
  end

endmodule