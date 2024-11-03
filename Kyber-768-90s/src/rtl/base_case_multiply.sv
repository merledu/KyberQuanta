module base_case_multiply(
    input logic [15:0] a0,      // Coefficient a0
    input logic [15:0] a1,      // Coefficient a1
    input logic [15:0] b0,      // Coefficient b0
    input logic [15:0] b1,      // Coefficient b1
    input logic [15:0] gamma,   // Modulus value gamma
    input logic [15:0] q,       // Modulus q
    output logic [15:0] c0,     // Result coefficient c0
    output logic [15:0] c1      // Result coefficient c1
);

    // Temporary variables for intermediate calculations
    logic [31:0] temp_c0;
    logic [31:0] temp_c1;

    always_comb begin
        // Extend 'q' to 32 bits before performing modulo operation
        temp_c0 = (a0 * b0 + a1 * b1 * gamma) % {16'b0, q};
        temp_c1 = (a0 * b1 + a1 * b0) % {16'b0, q};

        // Assign the lower 16 bits to the outputs
        c0 = temp_c0[15:0];
        c1 = temp_c1[15:0];
    end
endmodule