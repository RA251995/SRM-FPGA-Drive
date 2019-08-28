`timescale 1ns / 1ps

module top(
    input wire MCLK,
    
    input wire sw_select_display,
    input wire hallR,
     
    input wire MISO,
    output wire CLK,
    output wire CS,
    
    output wire [13:0] LED,
    output wire [6:0] cathode,
    output wire [7:0] anode
    );
    
    wire [3:0] digit8;
    wire [3:0] digit7;
    wire [3:0] digit6;
    wire [3:0] digit5;
    wire [3:0] digit4;
    wire [3:0] digit3;
    wire [3:0] digit2;
    wire [3:0] digit1;
    wire [13:0] number;
    
    assign digit8 = (sw_select_display) ? 13 : 10;
    assign digit7 = (sw_select_display) ? 15 : 11;
    assign digit6 = (sw_select_display) ? 14 : 12;
    assign digit5 = (sw_select_display) ? 15 : 15;
    
    wire [13:0] current;
    current_measurement current_measurement_wrapper(.MCLK(MCLK), .MISO(MISO), .LED(LED), .CLK(CLK), .CS(CS), .current(current));
    wire [13:0] freq;
    speed_measurement speed_measurement_instance (.clk(MCLK), .hallR(hallR), .freq(freq));
 
    assign number = (sw_select_display) ? current : freq;
     
    bcd bcd_wrapper (.number(number), .thousands(digit4), .hundreds(digit3), .tens(digit2), .ones(digit1));
    seven_segment_display seven_segment_display_wrapper (.clk(MCLK), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .digit5(digit5), .digit6(digit6), .digit7(digit7), .digit8(digit8), .cathode(cathode), .anode(anode));
    
endmodule
