`timescale 1ns / 1ps

module current_measurement #(parameter ZERO_SHIFT = 2048) (
    input wire MCLK, 
    input wire MISO,
    output reg CLK = 1'b0,
    output reg CS = 1'b1,
    output reg [11:0] current = {12{1'b0}}
    );
    
    localparam data_len = 16;
    localparam RDY = 2'b00, RECEIVE = 2'b01, STOP = 2'b10, WAIT = 2'b11;
    
    reg [1:0] state = WAIT;
    reg [data_len-1:0] data = 0;
    reg [5:0] clkdiv = 0;
    reg [3:0] index = 0;
    reg [2:0] wait_count = 2;
    
    reg [11:0] current_prev = 12'b0;
    
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
                    if (data[12:1] < ZERO_SHIFT) begin
                        current = current_prev;
                    end
                    else begin
                        current = data[12:1]-ZERO_SHIFT;
                        current_prev = data[12:1]-ZERO_SHIFT;
                    end
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