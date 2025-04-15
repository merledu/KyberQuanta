`timescale 1ns / 1ps
module bytes_to_bits #(
    parameter BYTE_COUNT = 256,          
    parameter BIT_COUNT = BYTE_COUNT * 8 
)(
    input logic [7:0] B [0:BYTE_COUNT-1], 
    input logic [$clog2(BYTE_COUNT):0] len, 
    output logic [BIT_COUNT-1:0] b     
);

    integer i, j; 

    always_comb begin
        b = '0; 
        
        for (i = 0; i < len && i < BYTE_COUNT; i++) begin
            for (j = 0; j < 8; j++) begin
                b[8 * i + j] = B[i][j]; 
            end
        end
    end

endmodule