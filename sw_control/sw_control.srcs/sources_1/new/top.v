`timescale 1ns / 1ps

module top(
    input wire [7:0] sw,
    output wire brown_top,
    output wire yellow_top,
    output wire black_top,
    output wire gray_top, 
    output wire brown_bottom, 
    output wire yellow_bottom,
    output wire black_bottom, 
    output wire gray_bottom
    );
    
    assign  brown_top    = sw[0];    
    assign  yellow_top   = sw[1];
    assign  black_top    = sw[2];
    assign  gray_top     = sw[3];
    assign  brown_bottom = sw[4];
    assign  yellow_bottom= sw[5];
    assign  black_bottom = sw[6];
    assign  gray_bottom  = sw[7];
endmodule
