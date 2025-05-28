`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 09:46:07 PM
// Design Name: 
// Module Name: bits_to_bytes
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bits_to_bytes #(
    parameter BIT_LENGTH = 2048, 
    parameter BYTE_LENGTH = BIT_LENGTH / 8
) (
    input  logic [BIT_LENGTH-1:0] bit_array,
    output logic [7:0] byte_array [BYTE_LENGTH-1:0]  
);

    integer i, j;

    always_comb begin
        for (i = 0; i < BYTE_LENGTH; i = i + 1) begin
            byte_array[i] = 8'b0; 
            for (j = 0; j < 8; j = j + 1) begin
                byte_array[i][j] = bit_array[i * 8  +( j )];
            end
        end
    end

endmodule
