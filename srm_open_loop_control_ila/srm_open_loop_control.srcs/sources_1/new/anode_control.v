`timescale 1ns / 1ps

module anode_control(
    input wire [2:0] refresh_count,
    output reg [7:0] anode
    );
    
    always @ (refresh_count)
        case (refresh_count)
            3'b000 : anode = 8'b1111_1110;
            3'b001 : anode = 8'b1111_1101;
            3'b010 : anode = 8'b1111_1011;
            3'b011 : anode = 8'b1111_0111;
            3'b100 : anode = 8'b1110_1111;
            3'b101 : anode = 8'b1101_1111;
            3'b110 : anode = 8'b1011_1111;
            3'b111 : anode = 8'b0111_1111;
        endcase
endmodule
