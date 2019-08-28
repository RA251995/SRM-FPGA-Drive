`timescale 1ns / 1ps

module bcd(
    input [13:0] number,        // 14-bit number
    output reg [3:0] thousands,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
    );
    
    reg [29:0] shift_reg;       // 14 + 4 * 4 = 30
    integer i;
    
    always @ (number) begin
        shift_reg[29:14] = 0;
        shift_reg[13:0] = number;
        
        for (i=0; i<14; i=i+1) begin
            if(shift_reg[17:14] >= 5)
                shift_reg[17:14] = shift_reg[17:14] + 3;
            if(shift_reg[21:18] >= 5)
                shift_reg[21:18] = shift_reg[21:18] + 3;
            if(shift_reg[25:22] >= 5)
                shift_reg[25:22] = shift_reg[25:22] + 3; 
            if(shift_reg[29:26] >= 5)
                shift_reg[29:26] = shift_reg[29:26] + 3;  
                
            shift_reg = shift_reg << 1;  
        end
        
        thousands = shift_reg[29:26];
        hundreds = shift_reg[25:22];
        tens = shift_reg[21:18];
        ones = shift_reg[17:14];  
    end
    
endmodule
