`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 07:10:31 PM
// Design Name: 
// Module Name: encode
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


module encode #(parameter D = 8, BYTE_LEN = 32) (
    input  logic signed [15:0] F [255:0],            // Input 16-bit signed array
    output logic [7:0] B [BYTE_LEN * D - 1 : 0]       // Output 8-bit byte array
);

    logic [(BYTE_LEN * D * 8) - 1:0] bit_array;      // Flattened bit array
    integer i, j;

    // Instantiate `bits_to_bytes` with corrected parameters
    bits_to_bytes #(
        .BIT_LENGTH(BYTE_LEN * D * 8),
        .BYTE_LENGTH(BYTE_LEN * D)
    ) btb (
        .bit_array(bit_array),
        .byte_array(B)
    );
    logic signed [15:0] a;
    always_comb begin
        // Initialize the bit array
        bit_array = '0;

        // Populate the bit array with encoded values
        for (i = 0; i < 256; i++) begin
            a = F[i];
            for (j = 0; j < D; j++) begin
                bit_array[i * D + j] = a[0];  // Extract the least significant bit
                a = a >> 1;                  // Shift right by 1
            end
        end
    end

endmodule
