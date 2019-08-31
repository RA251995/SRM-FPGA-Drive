`timescale 1ns / 1ps

module top(
    input wire clk,
    
    input wire sw_select_display,
    
    input wire hallR,
    input wire hallB,
    input wire hallY,
    input wire hallG,
    
    input wire I_MISO_1,
    output wire I_CLK_1,
    output wire I_CS_1,
    
    input wire I_MISO_2,
    output wire I_CLK_2,
    output wire I_CS_2,
    
    input wire I_MISO_3,
    output wire I_CLK_3,
    output wire I_CS_3,
    
    input wire I_MISO_4,
    output wire I_CLK_4,
    output wire I_CS_4,
    
    output wire DAC_SCLK,
    output wire DAC_SYNC_,
    output wire DAC_DIN,
    
    output wire UART_RXD_OUT,
    
    output reg brown_top,
    output reg yellow_top,
    output reg black_top,
    output reg gray_top, 
    output reg brown_bottom, 
    output reg yellow_bottom,
    output reg black_bottom, 
    output reg gray_bottom,
    
    output wire [3:0] LED,
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
    wire [11:0] number;
    
    assign digit8 = (sw_select_display) ? 13 : 10;
    assign digit7 = (sw_select_display) ? 15 : 11;
    assign digit6 = (sw_select_display) ? 14 : 12;
    assign digit5 = (sw_select_display) ? 15 : 15;
    
    wire [11:0] current1;
    wire [11:0] current2;
    wire [11:0] current3;
    wire [11:0] current4;
    current_measurement current_measurement_wrapper1(.MCLK(clk), .MISO(I_MISO_1), .CLK(I_CLK_1), .CS(I_CS_1), .current(current1));
    current_measurement current_measurement_wrapper2(.MCLK(clk), .MISO(I_MISO_2), .CLK(I_CLK_2), .CS(I_CS_2), .current(current2));
    current_measurement current_measurement_wrapper3(.MCLK(clk), .MISO(I_MISO_3), .CLK(I_CLK_3), .CS(I_CS_3), .current(current3));
    current_measurement current_measurement_wrapper4(.MCLK(clk), .MISO(I_MISO_4), .CLK(I_CLK_4), .CS(I_CS_4), .current(current4));
    spi_dac spi_dac_current(.CLK(clk), .DATA_A(current1), .DATA_B(current2), .DATA_C(current3), .DATA_D(current4), .SCLK(DAC_SCLK), .SYNC_(DAC_SYNC_), .DIN(DAC_DIN));
    wire [11:0] freq;
    speed_measurement speed_measurement_instance (.clk(clk), .hallR(hallR), .freq(freq));
    
    assign number = (sw_select_display) ? current1 : freq;
    
    bcd bcd_wrapper (.number(number), .thousands(digit4), .hundreds(digit3), .tens(digit2), .ones(digit1));
    seven_segment_display seven_segment_display_wrapper (.clk(clk), .digit1(digit1), .digit2(digit2), .digit3(digit3), .digit4(digit4), .digit5(digit5), .digit6(digit6), .digit7(digit7), .digit8(digit8), .cathode(cathode), .anode(anode));
    
    reg UART_send =1'b0;
    reg [7:0] UART_data_lsb = 8'b0;
    reg [7:0] UART_data = 8'b0;
    wire UART_ready;
    reg msb = 1'b1;
    UART_tx #(115200, 10) UART_tx_wrapper(.clk(clk), .send(UART_send), .data(UART_data), .ready(UART_ready), .tx(UART_RXD_OUT));
    always @ (negedge clk) begin
        UART_send = 1'b0;
        if (UART_ready == 1'b1) begin
            if (msb == 1'b1) begin
                UART_data_lsb = current1[7:0];
                UART_data = {4'b0, current1[11:8]};
                msb = 1'b0;
            end
            else begin
                UART_data = UART_data_lsb;
                msb = 1'b1;
            end
            UART_send = 1'b1;
        end
    end
    
    assign LED[3] = hallR;
    assign LED[2] = hallB;
    assign LED[1] = hallY;
    assign LED[0] = hallG;
    
    wire update_clk;
    clock_divider #(49_999) update_clock_generator_wrapper (.clk(clk), .div_clk(update_clk));
    
    always @ (posedge update_clk) begin
        case({hallR, hallB, hallY, hallG})
            4'b1001 : begin
                    gray_top <= 1;
                    gray_bottom <= 1; 
                    black_top <= 0;
                    black_bottom <= 0;
                    yellow_top <= 0;
                    yellow_bottom <= 0;
                    brown_top <= 0;
                    brown_bottom <= 0;  
                end
            4'b1100 : begin
                    gray_top <= 0;
                    gray_bottom <= 0; 
                    black_top <= 1;
                    black_bottom <= 1;
                    yellow_top <= 0;
                    yellow_bottom <= 0;
                    brown_top <= 0;
                    brown_bottom <= 0;   
                end
            4'b0110 : begin
                    gray_top <= 0;
                    gray_bottom <= 0; 
                    black_top <= 0;
                    black_bottom <= 0;
                    yellow_top <= 1;
                    yellow_bottom <= 1;
                    brown_top <= 0;
                    brown_bottom <= 0;  
                end
            4'b0011 : begin
                    gray_top <= 0;
                    gray_bottom <= 0; 
                    black_top <= 0;
                    black_bottom <= 0;
                    yellow_top <= 0;
                    yellow_bottom <= 0;
                    brown_top <= 1;
                    brown_bottom <= 1;   
                end
        endcase
    end

endmodule
