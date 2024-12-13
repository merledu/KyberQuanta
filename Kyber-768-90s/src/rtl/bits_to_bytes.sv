`timescale 1ns / 1ps
module bits_to_bytes #(
    parameter BIT_LENGTH = 2048, 
    parameter BYTE_LENGTH = BIT_LENGTH / 8
) (
    input  logic [BIT_LENGTH-1:0] bit_array,
    output logic [BYTE_LENGTH-1:0] byte_array
);

    integer i; 

    always_comb begin

        byte_array = '0;

        for (i = 0; i < BIT_LENGTH; i = i + 1) begin
            byte_array[i / 8] = byte_array[i / 8] | (bit_array[i] << (i % 8));
        end
    end

endmodule