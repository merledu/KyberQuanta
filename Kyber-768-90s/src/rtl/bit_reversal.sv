module bit_reversal(
    input logic [6:0] i,      // Input integer to be bit-reversed (7-bit input)
    input logic [2:0] k,      // Number of bits to reverse
    output logic [6:0] rev_i  // Output bit-reversed integer
);

    integer j;
    always_comb begin
        rev_i = 7'b0;  // Initialize output to zero
        for (j = 0; j < k; j = j + 1) begin
            rev_i[j] = i[{29'b0, k} - 1 - j];
        end
    end
endmodule
