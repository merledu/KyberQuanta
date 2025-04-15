`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 07:14:42 PM
// Design Name: 
// Module Name: ntt_multiplication
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiply_ntts(
    input logic clk,                 // Clock signal
    input logic reset,               // Reset signal
    input logic [15:0] f [255:0],
    input logic [15:0] g [255:0],
    input logic [15:0] zetas [127:0], // Zetas now as an input
    output logic [15:0] h [255:0]     // Output result
);

    genvar j;
    generate
        for (j = 0; j < 128; j = j + 1) begin : base_mult

            // Intermediate signals for base multiplication
            logic [15:0] a0, a1, b0, b1, gamma, c0, c1;
            logic [7:0] temp_j;
            assign temp_j = j;

            // Assign inputs for base multiplication
            assign a0 = f[2 * j];
            assign a1 = f[2 * j + 1];
            assign b0 = g[2 * j];
            assign b1 = g[2 * j + 1];
            assign gamma = zetas[j];
            
            // Instantiate the base case multiplier
            base_case_multiply base_case_multiply_inst(
                .a0(a0),
                .a1(a1),
                .b0(b0),
                .b1(b1),
                .gamma(gamma),
                .c0(c0),
                .c1(c1)
            );

            // Sequential logic to store results
            always_ff @(posedge clk or posedge reset) begin
                if (reset) begin
                    h[2 * j] <= 16'd0;
                    h[2 * j + 1] <= 16'd0;
                end else begin
                    h[2 * j] <= c0;
                    h[2 * j + 1] <= c1;
                end
            end
        end
    endgenerate

endmodule
