`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire hallR,
    output wire [6:0] cathode,
    output wire [7:0] anode
    );
    
    reg [3:0] digit8 = 10;
    reg [3:0] digit7 = 11;
    reg [3:0] digit6 = 12;
    reg [3:0] digit5 = 15;
    wire [3:0] digit4;
    wire [3:0] digit3;
    wire [3:0] digit2;
    wire [3:0] digit1;
    reg [15:0] freq = 0; 
    bcd bcd_wrapper (.number(freq), .thousands(digit4), .hundreds(digit3), .tens(digit2), .ones(digit1));
    
    seven_segment_display seven_segment_display_wrapper (.clk(clk), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .digit5(digit5), .digit6(digit6), .digit7(digit7), .digit8(digit8), .cathode(cathode), .anode(anode));
    
    reg hallR_delayed = 0;
    reg [15:0] hall_count = 0;
    
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
