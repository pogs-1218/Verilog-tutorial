`default_nettype none
`timescale 1ns/1ps

// Led wave using wishbone bus
// Is it possible to use 'inout' keyword for data?
module wishbone(input clk,

                // wishbone interface ports
                input cyc,  // True from request to ack
                input stb,  // strobe
                input we,  // write or not
                input addr,   // address
                input [31:0] i_data, // 32-bit input data for write, ignored when reading

                output stall, // I am operating now. It is true if reading or writing is working.
                output reg ack,   // response when writing
                output  [31:0] o_data,   // 32-bit response when reading
                //////////////////////////////////////

                output reg [5:0] led
                );
  wire busy;
  reg [3:0] state;

  wire unused;
  assign unused = &{1'b0, cyc, addr, i_data};

  initial state = 0;
  initial ack = 1'b0;
  always @ (posedge clk) begin
    ack <= stb && !stall;
  end

  always @ (posedge clk) begin
    if(stb && we && !busy)
      state <= 4'h1;
    else if (state >= 4'hb)
      state <= 4'h0;
    else if (state != 0)
      state <= state + 1'b1;

    case(state)
    4'h1: led <= 6'h01;
    4'h2: led <= 6'h02;
    4'h3: led <= 6'h04;
    4'h4: led <= 6'h08;
    4'h5: led <= 6'h10;
    4'h6: led <= 6'h20;
    4'h7: led <= 6'h10;
    4'h8: led <= 6'h08;
    4'h9: led <= 6'h04;
    4'ha: led <= 6'h02;
    4'hb: led <= 6'h01;
    default: led <= 6'h0;
    endcase
  end

  assign busy = (state != 0);
  // I'm busy and I'm writing.
  assign stall = busy && we;
  // 28-bit + 4-bit
  assign o_data = {28'h0, state};

endmodule
