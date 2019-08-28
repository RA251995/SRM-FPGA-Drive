`timescale 1ns / 1ps

module top(
    input wire MCLK, 
    input wire MISO,
    output reg [13:0] LED = {14{1'b0}},
    output reg CLK = 1'b0,
    output reg CS = 1'b1,
    output wire [6:0] cathode,
    output wire [7:0] anode
    );
    
    reg [3:0] digit8 = 13;
    reg [3:0] digit7 = 15;
    reg [3:0] digit6 = 14;
    reg [3:0] digit5 = 15;
    wire [3:0] digit4;
    wire [3:0] digit3;
    wire [3:0] digit2;
    wire [3:0] digit1;
    reg [13:0] current = 0; 
    bcd bcd_wrapper (.number(current), .thousands(digit4), .hundreds(digit3), .tens(digit2), .ones(digit1));
    
    seven_segment_display seven_segment_display_wrapper (.clk(MCLK), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .digit5(digit5), .digit6(digit6), .digit7(digit7), .digit8(digit8), .cathode(cathode), .anode(anode));
    
    parameter data_len = 16;
    
    localparam RDY = 2'b00, RECEIVE = 2'b01, STOP = 2'b10, WAIT = 2'b11;
    
    reg [1:0] state = WAIT;
    reg [data_len-1:0] data = 0;
    reg [5:0] clkdiv = 0;
    reg [3:0] index = 0;
    reg [2:0] wait_count = 2;
    
    always @ (posedge MCLK) begin   // 1MHz CLK
        if (clkdiv == 6'd49) begin 
	       clkdiv <= 0; 
	       CLK <= ~CLK; 
	      end 
        else begin 
            clkdiv <= clkdiv + 1;
        end
    end
    
    always @ (negedge CLK) begin
        case (state) 
          RDY : begin
                    CS <= 0;
                    state <= RECEIVE; 
                    data <= 0;
                    index <= data_len-1;                 
                end
           RECEIVE: begin 
                    if (index == 0) 
                        state <= STOP; 
                    data[index] <= MISO; 
                    index <= index - 1; 
                end
            STOP: begin 
                    CS <= 1; 
                    state <= WAIT;
                    wait_count <= 1;
                    LED <= data[13:0];
                    current <= data[13:0];
                end
            WAIT : begin
                    wait_count = wait_count-1;
                    if (wait_count == 0) begin
                        state = RDY;
                    end
                end
        endcase
    end
    
endmodule

