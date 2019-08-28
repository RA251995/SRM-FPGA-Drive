`timescale 1ns / 1ps

module speed_measurement(
    input wire clk,
    input wire hallR,
    output reg [13:0] freq
    );
    
    reg hallR_delayed = 0;
    reg [13:0] hall_count = 0;
    
    integer clk_counter = 0;
    localparam CLK_DIV = 99_999_999;    // 1s
   
    always @ (posedge clk) begin
        if (hallR & ~hallR_delayed == 1'b1) begin
            hall_count = hall_count + 1;
        end
        hallR_delayed = hallR;
        
        if (clk_counter == CLK_DIV) begin
            freq = hall_count;
            hall_count = 0;
            clk_counter = 0;
        end
        else
            clk_counter = clk_counter + 1;
    end
endmodule
