`timescale 1ns/1ps
module bits_to_bytes #(parameter BYTE_LEN = 32) ( 
    input  logic [BYTE_LEN*8-1:0] bit_array,      
    output logic [7:0] B [0:BYTE_LEN-1] 
         
);
    integer i;

    always_comb begin
        for (i = 0; i < BYTE_LEN; i++) begin
            B[i] = 0; 
        end

       
        for (i = 0; i < BYTE_LEN * 8; i++) begin
            B[i / 8] = B[i / 8] + bit_array[i] * (2 ** ((i % 8))); 
        end
    end
endmodule