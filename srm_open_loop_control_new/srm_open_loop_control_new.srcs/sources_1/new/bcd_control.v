`timescale 1ns / 1ps

module bcd_control(
    input wire [2:0] refresh_count,

    input wire [3:0] digit1,
    input wire [3:0] digit2,
    input wire [3:0] digit3,
    input wire [3:0] digit4,
    input wire [4:0] digit5,
    input wire [4:0] digit6,
    input wire [4:0] digit7,
    input wire [4:0] digit8,
    
    output reg [4:0] digit_out = 0
    );
    
    always @ (refresh_count)
        case (refresh_count)
            3'b000 : digit_out = digit1;
            3'b001 : digit_out = digit2;
            3'b010 : digit_out = digit3;
            3'b011 : digit_out = digit4;
            3'b100 : digit_out = digit5;
            3'b101 : digit_out = digit6;
            3'b110 : digit_out = digit7;
            3'b111 : digit_out = digit8;
        endcase
    
endmodule
