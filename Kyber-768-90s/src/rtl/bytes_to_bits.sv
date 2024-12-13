`timescale 1ns / 1ps
module bytes_to_bits(
    input logic [7:0] B [31:0],   
    input logic [7:0] len,        
    output logic  [255:0] b       
);

    integer i, j; 

    always_comb begin 
       b = 256'b0;

         for (i = 0; i < len && i < 32; i++) begin
            for (j = 0; j < 8; j++) begin
                b[8 * i + j] = B[i][j];  
                
            end
        end
    end

endmodule
