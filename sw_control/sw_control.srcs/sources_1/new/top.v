`timescale 1ns / 1ps

module top(
    input wire [7:0] sw,
    
    input wire hallR,
    input wire hallB,
    input wire hallY,
    input wire hallG,
    
    output wire brown_top,
    output wire yellow_top,
    output wire black_top,
    output wire gray_top, 
    output wire brown_bottom, 
    output wire yellow_bottom,
    output wire black_bottom, 
    output wire gray_bottom,
    
    output wire [3:0] LED
    );
    
    assign  brown_top     = sw[0];    
    assign  brown_bottom  = sw[1];
    assign  yellow_top    = sw[2];
    assign  yellow_bottom = sw[3];
    assign  black_top     = sw[4];
    assign  black_bottom  = sw[5];
    assign  gray_top      = sw[6];
    assign  gray_bottom   = sw[7];
    
    assign LED[3] = hallR;
    assign LED[2] = hallB;
    assign LED[1] = hallY;
    assign LED[0] = hallG;
endmodule
