`default_nettype none

// Is it possible to use 'inout' keyword for data?
module whishbone(input clk,
                 input cyc,  // True from request to ack
                 input stb,  // strobe
                 input we,  // write or not
                 input addr,   // address
                 input i_data, // input data for write, ignored when reading
                 output stall, // I am operating now. It is true if reading or writing is working.
                 output ack,   // response when writing
                 output o_data);  // response when reading
    

endmodule
