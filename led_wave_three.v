`default_nettype none

module led_wave_three(input clk,
                      input request,
                      output busy,
                      output reg [5:0] led);
  reg [3:0] state;

  initial state = 4'h0;
  // Set the idle state with a request & a busy
  always @ (posedge clk) begin
    if(request && !busy)
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

endmodule
