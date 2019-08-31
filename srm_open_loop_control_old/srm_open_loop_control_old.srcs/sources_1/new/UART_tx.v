`timescale 1ns / 1ps
module UART_tx #(parameter BAUD_RATE = 9600, parameter BIT_INDEX_MAX = 10) (
    input clk,
    input send,
    input [7:0] data,
    output ready,
    output tx 
    );
    
    localparam [26:0] baud_timer = 100_000_000/BAUD_RATE;
    localparam READY = 2'b00, LOAD_BIT = 2'b01, SEND_BIT = 2'b10;
    
    reg [1:0] state = READY;
    reg [26:0] timer = 0;
    reg [9:0] txData;
    reg [3:0] bitIndex;
    reg txBit = 1'b1;
    
    always @ (posedge clk)
        case(state)
            READY: begin
                if (send) begin
                    txData <= {1'b1,data,1'b0};
                    state <= LOAD_BIT;
                end
                timer <= 27'b0;
                bitIndex <= 0;
                txBit <= 1'b1;
            end
            LOAD_BIT: begin
                state <= SEND_BIT;
                bitIndex <= bitIndex + 1'b1;
                txBit <= txData[bitIndex];
            end
            SEND_BIT: begin
                if (timer == baud_timer) begin
                    timer <= 27'b0;
                    if (bitIndex == BIT_INDEX_MAX)
                        state <= READY;
                    else 
                        state <= LOAD_BIT;
                end
                else
                    timer <= timer + 1'b1;
            end
            default: begin
                state <= READY;
            end
        endcase
        
        assign tx = txBit;
        assign ready = (state == READY);
endmodule
