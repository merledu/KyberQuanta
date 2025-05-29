`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 09:54:06 PM
// Design Name: 
// Module Name: decode
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



module decode #(parameter ELL = 12, parameter NUM_COEFFS = 256, parameter BYTE_COUNT = 32 * ELL / 8)(
    input logic [7:0] byte_array [0:BYTE_COUNT-1],      // Input byte array
//    input logic [$clog2(BYTE_COUNT):0] len,            // Number of valid bytes
input logic [15:0] len,  // or [11:0] if you want minimum width

    output logic [ELL-1:0] coeffs [0:NUM_COEFFS-1]     // Output coefficients
);

    localparam BIT_COUNT = BYTE_COUNT * 8;

    // Intermediate bit array
    logic [BIT_COUNT-1:0] bit_array;

    // Instantiate the bytes_to_bits module
    bytes_to_bits #(
        .BYTE_COUNT(BYTE_COUNT),
        .BIT_COUNT(BIT_COUNT)
    ) btb_inst (
        .B(byte_array),
        .len(len),
        .b(bit_array)
    );

    // Compute coefficients from bit array
    integer i, j;
   always @(*) begin
        coeffs = '{default: 0}; // Initialize all coefficients to 0
        for (i = 0; i < NUM_COEFFS; i++) begin
            if (i * ELL < BIT_COUNT) begin
                for (j = 0; j < ELL; j++) begin
                    if (i * ELL + j < BIT_COUNT) begin
                        coeffs[i] = coeffs[i] + (bit_array[i * ELL + j] << j);
                    end
                end
                coeffs[i] = coeffs[i] % (2 ** ELL);
            end
        end
    
        // Debug: print the output coefficients
//        for (i = 0; i < NUM_COEFFS; i++) begin
//            $display("hicoeffs[%0d] = %0d", i, coeffs[i]);
//        end
    end

endmodule

