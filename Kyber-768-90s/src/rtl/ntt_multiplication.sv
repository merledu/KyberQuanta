`timescale 1ns / 1ps
module multiply_ntts(
    input logic [15:0] f [255:0],
    input logic [15:0] g [255:0],   
//    input logic [15:0] q,          
    input logic [15:0] zetas [127:0],  // zetas now as an input
    output logic [15:0] h [255:0]    
);


    genvar j;
    generate
        for (j = 0; j < 128; j = j + 1) begin : base_mult

            logic [15:0] a0, a1, b0, b1, gamma, c0, c1;
            logic [7:0] temp_j;
            assign temp_j = j;
            // $display(j);
            assign a0 = f[2 * j];
            assign a1 = f[2 * j + 1];
            assign b0 = g[2 * j];
            assign b1 = g[2 * j + 1];
            assign gamma = zetas[j];
            
            base_case_multiply base_case_multiply_inst(
                .a0(a0),
                .a1(a1),
                .b0(b0),
                .b1(b1),
                .gamma(gamma),
                .c0(c0),
                .c1(c1)
            );
            
            always_comb begin
            $display(j, a0, a1, gamma, c0);
            $display(j, b0, b1, gamma, c1);
                h[2 * j] = c0;
                h[2 * j + 1] = c1;
            end
        end
    endgenerate
endmodule