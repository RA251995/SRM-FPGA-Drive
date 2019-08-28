`timescale 1ns / 1ps

module refresh_counter(
    input wire refresh_clk,
    output reg [2:0] refresh_count = 0
    );
    
    always @ (posedge refresh_clk)
        refresh_count <= refresh_count + 1;
endmodule
