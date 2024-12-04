`timescale 1ns / 1ps
module bits_to_bytes #(
    parameter BIT_LENGTH = 256,  // Parameter for the total number of input bits
    parameter BYTE_LENGTH = BIT_LENGTH / 8 // Parameter for the total number of output bytes
) (
    input  logic [BIT_LENGTH-1:0] bit_array, // Input bit array
    output logic [BYTE_LENGTH-1:0] byte_array // Output byte array
);
    // Integer for loop iteration
    integer i;

    always_comb begin
        // Initialize the output array to 0
        byte_array = '0;
        
        // Iterate through each bit in the input array
        for (i = 0; i < BIT_LENGTH; i++) begin
            // Accumulate bits into the appropriate byte
            byte_array[i / 8] = byte_array[i / 8] | (bit_array[i] << (i % 8));
        end
    end

endmodule
