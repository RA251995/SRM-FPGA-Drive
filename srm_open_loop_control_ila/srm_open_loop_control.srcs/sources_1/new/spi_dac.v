`timescale 1ns / 1ps

module spi_dac(
                input wire CLK,  // 100MHz CLK
                input wire [11:0] DATA,
                output reg SCLK = 0,
                output reg SYNC_ = 1,
                output reg DIN
                );
                
    localparam RDY = 2'b00, START = 2'b01, STOP = 2'b10, WAIT = 2'b11;
    
    reg reset = 1'b1;
    reg [1:0] state = WAIT;
    reg [5:0] index = 0;
    reg [2:0] wait_count = 2;
    
    reg enable_vref = 1'b1;
    
    reg [3:0] command;
    reg [3:0] address = 4'b0000;
    reg [11:0] data;
    reg [31:0] spi_buffer;
    
    reg [5:0] clkdiv = 0;
      
    always @ (posedge CLK)  begin // 50MHz SCLK
        if (clkdiv == 6'd49) begin 
	       clkdiv <= 0; 
	       SCLK <= ~SCLK; 
	      end 
        else begin 
            clkdiv <= clkdiv + 1;
        end
    end
    
    always @ (posedge CLK) begin
        if (reset == 1'b1) begin
            command = 4'b1000;  // Setup internal VREF
            spi_buffer = {{4{1'bx}},command,{23{1'bx}},enable_vref};   
        end
        else begin
            command = 4'b0011;  // Write to and update DAC Channel
            data = DATA; 
            spi_buffer = {{4{1'bx}},command,address,data,{8{1'bx}}};  
        end
    end
    
    always @ (posedge SCLK) begin
        case (state)
            RDY : begin
                    SYNC_ <= 0;
                    state <= START;
                    index <= 31;
                    DIN = spi_buffer[index];    
                end
            START : begin
                    index = index-1;
                    DIN = spi_buffer[index];
                    if (index == 0) begin
                        state = STOP;
                    end
                end 
            STOP : begin
                    SYNC_ <= 1;
                    state <= WAIT;
                    wait_count <= 1;
                    reset <= 1'b0; 
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