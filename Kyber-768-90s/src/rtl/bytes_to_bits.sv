module bytes_to_bits(
    input logic [7:0] B [31:0],   
    input logic [7:0] len,        
    output logic  b   [255:0]     
);

    integer i, j;
    logic [7:0] C [31:0];  

    always_comb begin 
       
        for (i = 0; i < len; i++) begin
            C[i] = B[i];
        end

        for (i = 0; i < len; i++) begin
            for (j = 0; j < 8; j++) begin
                b[8 * i + j] = C[i][0];                 
                C[i] = C[i] >> 1;  
                
            end
        end
    end

endmodule
