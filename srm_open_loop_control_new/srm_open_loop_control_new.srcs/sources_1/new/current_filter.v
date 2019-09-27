`timescale 1ns / 1ps

module current_filter #(parameter ZERO_SHIFT = 2039) (
    input [11:0] current_in,
    output [11:0] current_out
    );
    
    reg [11:0] current_prev = 12'b0;
    reg [11:0] current_new = 12'b0;
    reg [11:0] current_raw = 12'b0;
    always @ (current_in) begin
        current_raw = current_in;
        if (current_raw < 2039) begin
            current_new = current_prev;
        end
        else begin
            {current_new,current_prev} = {2{current_raw-ZERO_SHIFT}};
        end
    end
    
    assign current_out = current_new;
endmodule
