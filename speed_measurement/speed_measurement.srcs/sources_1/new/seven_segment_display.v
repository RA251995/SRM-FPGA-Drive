`timescale 1ns / 1ps

module seven_segment_display(
    input wire clk,
    input wire [3:0] digit1,
    input wire [3:0] digit2,
    input wire [3:0] digit3,
    input wire [3:0] digit4,
    input wire [3:0] digit5,
    input wire [3:0] digit6,
    input wire [3:0] digit7,
    input wire [3:0] digit8,
    output wire [6:0] cathode,
    output wire [7:0] anode
    );
    
    wire refresh_clk;
    clock_divider #(4999) refresh_clock_generator_wrapper (.clk(clk), .div_clk(refresh_clk));
    
    wire [2:0] refresh_count;
    refresh_counter refresh_counter_wrapper (.refresh_clk(refresh_clk), .refresh_count(refresh_count));
    
    anode_control anode_control_wrapper (.refresh_count(refresh_count), .anode(anode));
    
    wire [3:0] digit_out;
    bcd_control bcd_control_wrapper (.refresh_count(refresh_count), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .digit5(digit5), .digit6(digit6), .digit7(digit7), .digit8(digit8), .digit_out(digit_out));
    
    bcd_to_cathodes bcd_to_cathodes_wrapper(.digit(digit_out), .cathode(cathode));

endmodule
