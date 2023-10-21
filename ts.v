`timescale 1ns/1ps

module ts;
  reg val;

  initial begin
    $dumpfile("ts.vcd");
    $dumpvars(0, ts);

    val <= 0;
    #1 $display("T=%0t At time #1", $realtime);
    val <= 1;

    #0.49 $display("T=%0t At time #0.49", $realtime);
    val <= 0;
    
    #0.50 $display("T=%0t At time #0.50", $realtime);
    val <= 1;

    #0.51 $display("T=%0t At time #0.51", $realtime);
    val <= 0;

    #5 $display("T=%0t At time #5", $realtime);
  end
endmodule