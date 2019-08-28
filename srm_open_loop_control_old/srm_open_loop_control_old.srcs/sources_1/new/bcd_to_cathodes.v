`timescale 1ns / 1ps

module bcd_to_cathodes(
    input wire [3:0] digit,
    output reg [6:0] cathode = 0
    );
    
    always @ (digit)
        case (digit)
            0 : cathode = 7'b000_0001;
            1 : cathode = 7'b100_1111;
            2 : cathode = 7'b001_0010;
            3 : cathode = 7'b000_0110;
            4 : cathode = 7'b100_1100;
            5 : cathode = 7'b010_0100;
            6 : cathode = 7'b010_0000;
            7 : cathode = 7'b000_1111;
            8 : cathode = 7'b000_0000;
            9 : cathode = 7'b000_0100;
            10 : cathode = 7'b000_1000; // R
            11 : cathode = 7'b001_1000; // P
            12 : cathode = 7'b010_0100; // S
            13 : cathode = 7'b100_1111; // I
            14 : cathode = 7'b000_1000; // A
            15 : cathode = 7'b111_1111; // Blank
            default : cathode = 7'b111_1111;
        endcase
    
endmodule
