/*
Key concepts:
0. State and transitions
1. Output depends on only a current state

Define state
localparam vs parameter
How many states? -> The size of state variable.

For example,
initial state -> state 1 -> state 2 -> state 3 -> state 4
Total state: 5
So that the size of state should be at least 3 (2^3 = 8)
Because 2^2(=4) is too small.

Remainng bits?
Available state: 8,
Used state: 5,
3-bits are remaining? Is it error-prone?
How to solve it?

Keep track of the current state
How? Why?
To define the next state.

*/
module moore_fsm(input clk,
                 input reset,
                 input a,
                 input b,
                 output output1,
                 output output2,
                 output reg [2:0] status);
  localparam STATE_initial = 3'd0,
             STATE_1 = 3'd1,
             STATE_2 = 3'd2,
             STATE_3 = 3'd3,
             STATE_4 = 3'd4,
             STATE_5_PlaceHolder = 3'd5,
             STATE_6_PlaceHolder = 3'd6,
             STATE_7_PlaceHolder = 3'd7;

  reg [2:0] current_state;
  reg [2:0] next_state;

  always @ (posedge clk) begin
    if (reset) current_state <= STATE_initial;
    else current_state <= next_state;
  end

  always @ (*) begin
    next_state = current_state;
    case (current_state)
      STATE_1: begin
        if (a & b)
          next_state = STATE_2;
      end
      STATE_2: begin
        if(a)
          next_state = STATE_3;
      end
      STATE_3: begin
        if (a & !b)
          next_state = STATE_4;
        else if (!a & b)
          next_state = STATE_initial;
      end
      STATE_4:begin
      end
      STATE_5_PlaceHolder: next_state = STATE_initial;
      STATE_6_PlaceHolder: next_state = STATE_initial;
      STATE_7_PlaceHolder: next_state = STATE_initial;
    endcase
  end

  assign output1 = (current_state == STATE_1) || (curren_state == STATE_2);
  assign output2 = (current_state == STATE_2);

  always @ (*) begin
    case (current_state)
      STATE_2: status = 3'b010;
      STATE_3: status = 3'b011;
    endcase
  end


endmodule