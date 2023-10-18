module syntax(clock, reset, req_0, req_1, gnt_0, gnt_1);
  // input ports
  input clock;
  input reset;
  input req_o;
  input req_1;

  // output ports
  output gnt_0;
  output gnt_1;


  // bi-directional ports
  inout read_enable;

  // vector
  // MSB:LSB
  inout [7:0] address;

  // register and wire
  // can store , doesn't
  wire and_gate_output;
  reg d_flip_flop_output;
  reg [7:0] address_bus; // address_bus is a little-endian 8-bit register

  // if-else
  if (read_enable == 1'b1) begin
    data = 10;
    address = 16'hDEAD;
  end else begin
    data = 11;
  end

  // case
  case(address)
    0: $display("111");
    1: $display("222");
    2: $display("333");
    default: $display("default case");
  endcase

  // while
  while(free_time) begin
    $display("Continue");
  end

  // for
  for (i = 0; i < 16; i = i+1) begin
    $display("Current value %d", i);
  end

  // repeat
  repeat(16) begin
    $display("Current value: %d", i);
    i = i + 1
  end


  // Variable assignment
  // two type of elements, combinational and sequential.

  // intial blocks
  // execute only once when starting.
  initial begin
    clock = 0;
    reset = 0;
    req_0 = 0;
    req_1 = 0;
  end

  // always blocks
  // with a sensitive list
  // The block will be triggered @ "at" the condition in paranthesis 
  // below is the mux sample.
  always @ (a or b or sel)
  begin
    y = 0;
    if (sel == 0) begin
      y = a;
    end else begin
      y = b;
    end
  end


  // two types of the sensitive list
  // level sensitive(combinational circuits) and edge sensitive(flip flop)
  always @ (posedge clk)
  if (reset == 0) begin
    y <= 0;
  end else if(sel == 0) begin
    y <= a;
  end else begin
    y <= b;
  end

  // with delay
  // #5, delays it execution by 5 time units.
  always begin
    #5 clk = ~clk
  end

  // assign statement
  assign out = (enable) ? data : 1'bz;

  // task and function
  // what's difference between them?
  // presence of delay and return value.
  function parity;
  input [31:0] data;
  integer i;
  begin
    parity = 0;
    for(i = 0; i < 32; i = i + 1) begin
      parity = parity ^ data[i];
    end
  end
  endfunction

endmodule