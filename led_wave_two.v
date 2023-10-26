// V shaped led wave
// 0: 0b0000_0000
// 1: 0b0000_0001
// 2: 0b0000_0010
// 3: 0b0000_0100
// ...
// 7: 0b0100_0000
// 8: 0b1000_0000
// 9: 0b0100_0000
// ...
// 15: 0b0000_0001
module led_wave_two(input clk,
                    output reg[7:0] led);
  reg [3:0] led_index;

  initial led_index = 0;
  always @ (posedge clk) begin
    if(led_index >= 4'he)
      led_index <= 0;
    else
      led_index <= led_index + 1'b1;

    case(led_index)
    4'h0: led <= 8'h01;
    4'h1: led <= 8'h02;
    4'h2: led <= 8'h04;
    4'h3: led <= 8'h08;
    4'h4: led <= 8'h10;
    4'h5: led <= 8'h20;
    4'h6: led <= 8'h40;
    4'h7: led <= 8'h80;
    4'h8: led <= 8'h40;
    4'h9: led <= 8'h20;
    4'ha: led <= 8'h10;
    4'hb: led <= 8'h08;
    4'hc: led <= 8'h04;
    4'hd: led <= 8'h02;
    endcase
  end

endmodule