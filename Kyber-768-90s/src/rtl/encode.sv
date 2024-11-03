module encode #(parameter D = 8, BYTE_LEN = 32) (
    input  logic signed [15:0] F [0:255],  
    output logic [7:0] B [0:BYTE_LEN*D-1]  
);

    logic [(BYTE_LEN*D*8)-1:0] bit_array;
    integer i, j;
    bits_to_bytes #(.BYTE_LEN(BYTE_LEN * D)) btb (
        .bit_array(bit_array),
        .B(B)
    );
    always_comb begin
        for (i = 0; i < BYTE_LEN * D * 8; i++) begin
            bit_array[i] = 0;
        end

        for (i = 0; i < 256; i++) begin
            logic signed [15:0] a = F[i];
            for (j = 0; j < D; j++) begin
                bit_array[i * D + j] = a[0];  
                a = a >> 1;                  
            end
        end
    end

endmodule
