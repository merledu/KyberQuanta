`timescale 1ns / 1ps

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
    logic [63:0] temp_c0;
    logic [63:0] temp_c1;
    logic [15:0] temp_mod_c0;
    logic [15:0] temp_mod_c1;

    // Constants
    localparam int Q = 3329;

    always_comb begin
        // Compute intermediate results
        temp_c0 = a0 * b0 + a1 * b1 * gamma;
        temp_c1 = a0 * b1 + a1 * b0;
//        $display("c0",a0, b0, a1, b1, gamma, temp_c0);
        // Apply modulo operation manually
        temp_mod_c0 = temp_c0 - (temp_c0 / Q) * Q;
        temp_mod_c1 = temp_c1 - (temp_c1 / Q) * Q;

        // Truncate the result to 16 bits
        c0 = temp_mod_c0[15:0];
        c1 = temp_mod_c1;
    end

endmodule