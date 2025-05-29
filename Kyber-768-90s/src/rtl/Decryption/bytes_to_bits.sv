`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 09:47:38 PM
// Design Name: 
// Module Name: bytes_to_bits
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


module bytes_to_bits #(
    parameter BYTE_COUNT = 256,          
    parameter BIT_COUNT = BYTE_COUNT * 8 
)(
    input logic [7:0] B [BYTE_COUNT-1:0], 
    input logic [$clog2(BYTE_COUNT):0] len, 
    output logic [BIT_COUNT-1:0] b     
);

    integer i, j; 

    always_comb begin
        b = '0; 
        for (i = 0; i < len && i < BYTE_COUNT; i++) begin
            for (j = 0; j < 8; j++) begin
                b[8 * i + j] = B[i][j]; // Assign each bit from B to b
            end
        end
    end

endmodule

