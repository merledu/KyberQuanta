module base_case_multiply(
    input logic [15:0] a0,      
    input logic [15:0] a1,      
    input logic [15:0] b0,      
    input logic [15:0] b1,      
    input logic [15:0] gamma,   
    output logic [15:0] c0,     
    output logic [15:0] c1      
);

    // Temporary 32-bit variables for intermediate calculations
    logic [31:0] temp_c0;
    logic [31:0] temp_c1;
    logic [31:0] temp_mod_c0;
    logic [31:0] temp_mod_c1;
    logic [15:0] mod_c0;
    logic [15:0] mod_c1;

    always_comb begin
        temp_c0 = a0 * b0 + a1 * b1 * gamma;
        temp_c1 = a0 * b1 + a1 * b0;

        // Apply modulo q operation by conditionally subtracting q
        temp_mod_c0 = temp_c0 % 3329;
        temp_mod_c1 = temp_c1 % 3329;

        // Truncate the result to 16 bits
        mod_c0 = temp_mod_c0[15:0];
        mod_c1 = temp_mod_c1[15:0];

        c0 = mod_c0;
        c1 = mod_c1;
    end
endmodule
