`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:01:04 PM
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



module encode #(parameter D = 12, BYTE_LEN = 32) (
    input logic start,
    output logic done,
    input  logic [15:0] F [255:0],            // Input 16-bit signed array
    output logic [7:0] B [BYTE_LEN * D - 1 : 0]       // Output 8-bit byte array
);

    logic [(BYTE_LEN * D * 8) - 1:0] bit_array;      // Flattened bit array
    integer i, j;

    // Instantiate bits_to_bytes with corrected parameters
    bits_to_bytes #(
        .BIT_LENGTH(BYTE_LEN * D * 8),
        .BYTE_LENGTH(BYTE_LEN * D)
    ) btb (
        .bit_array(bit_array),
        .byte_array(B)
    );
    logic signed [15:0] a;
       always @(*) begin
        bit_array = '0;
        done = 1'b0;

        if (start) begin
//            $display("Entering Encode");
//            for (i = 0; i < 256; i++) begin
//                $display("F[%0d] = %0d", i, F[i]);
//            end

            for (i = 0; i < 256; i++) begin
                a = F[i];
                for (j = 0; j < D; j++) begin
                    bit_array[i * D + j] = a[0];
                    a = a >> 1;
                end
            end

            done = 1'b1;
        end
    end

        

endmodule
