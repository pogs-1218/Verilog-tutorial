`default_nettype none

module test(input clk,
            input reset,
            input [7:0] data,
            output o_data);
  wire busy;
  reg [8:0] buffer;

  always @ (posedge clk) begin
    $display("buffer: %b", buffer);
    if(reset)
      buffer <= {data, 1'b0};
  end

  assign o_data = buffer[0];

endmodule