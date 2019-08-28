`timescale 1ns / 1ps

// CLK_DIV = 100MHz / (2 * Desired Frequency) - 1
// Default Desired Frequency = 10kHz

module clock_divider #(parameter CLK_DIV = 4_999) (
    input wire clk,
    output reg div_clk = 0
    );
    
    integer counter = 0;
    
    always @ (posedge clk)
        if (counter == CLK_DIV) begin
            div_clk = ~div_clk;
            counter <= 0;
        end
        else
            counter <= counter + 1;

endmodule
