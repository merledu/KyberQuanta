module parse #(parameter Q = 3329) (
    input  logic [15:0] B [767:0],  // Assuming B is 768 elements (since i increases by 3 each iteration)
    output logic [15:0] a [255:0]
);
    integer i, j;
    logic [15:0] d1, d2; 

    always_comb begin
        i = 0;
        j = 0;
        for (int k = 0; k < 256; k++) begin
            a[k] = 0;
        end
        while (j < 256) begin
            d1 = B[i] + 256 * (B[i + 1] % 16);    
            d2 = (B[i + 1] >> 4) + 16 * B[i + 2]; 
            if (d1 < Q) begin
                a[j] = d1;
                j = j + 1;
            end
            if (d2 < Q && j < 256) begin
                a[j] = d2; 
                j = j + 1;
            end

            i = i + 3;
        end 
    end
endmodule
