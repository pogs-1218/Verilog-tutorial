module memory(
  input clk,
  input rstn,
  input wr,
  input sel,
  input [15:0] wdata,
  output [15:0] rdata
);
  reg [15:0] register;

  always @ (posedge clk) begin
    if (!rstn)
      register <= 0;
    else
      if(sel & wr) 
        register <= wdata;
      else 
        register <= register;
  end

  assign rdata = (sel & ~wr) ? register : 0;

endmodule