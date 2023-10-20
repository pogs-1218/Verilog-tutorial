module arr_tb();
  reg [7:0] mem1;
  reg [7:0] mem2 [0:3];  // 8-bits register with depth=4
  reg [15:0] mem3 [0:3][0:1];  // 2-D array (4, 2)

  integer i;

  initial begin
    mem1 = 8'hA9;
    $display("mem1 = 0x%0h", mem1);

    mem2[0] = 8'hAA;
    mem2[1] = 8'hBB;
    mem2[2] = 8'hCC;
    mem2[3] = 8'hDD;
    for(i = 0; i < 4; i=i+1) begin
      $display("mem2[%0d] = 0x%0h", i, mem2[i]);
    end

    for(integer i = 0; i < 4; i++) begin
      for(integer j = 0; j < 2; j++) begin
        mem3[i][j] = i + j;
        $display("mem3[%0d][%0d] = 0x%0h", i, j, mem3[i][j]);
      end
    end
  end

endmodule