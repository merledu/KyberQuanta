`timescale 1ns / 1ps

module Compute_t_hat (
    input logic [15:0] A_hat [2:0][2:0][255:0],  // 3x3 matrix of 256-element polynomials
    input logic [15:0] s_hat [2:0][255:0],       // 3-element vector of 256-element polynomials
    output logic [15:0] t_hat [2:0][255:0]       // Output 3-element vector of 256-element polynomials
);

    logic [15:0] result0 [255:0], result1 [255:0], result2 [255:0];
    logic [15:0] result3 [255:0], result4 [255:0], result5 [255:0];
    logic [15:0] result6 [255:0], result7 [255:0], result8 [255:0];

    // Instantiate the multiply_ntts module calls
    multiply_ntts multiply0 (
        .f(A_hat[0][0]),
        .g(s_hat[0]),
        .h(result0)
    );
    multiply_ntts multiply1 (
        .f(A_hat[0][1]),
        .g(s_hat[1]),
        .h(result1)
    );
    multiply_ntts multiply2 (
        .f(A_hat[0][2]),
        .g(s_hat[2]),
        .h(result2)
    );

    multiply_ntts multiply3 (
        .f(A_hat[1][0]),
        .g(s_hat[0]),
        .h(result3)
    );
    multiply_ntts multiply4 (
        .f(A_hat[1][1]),
        .g(s_hat[1]),
        .h(result4)
    );
    multiply_ntts multiply5 (
        .f(A_hat[1][2]),
        .g(s_hat[2]),
        .h(result5)
    );

    multiply_ntts multiply6 (
        .f(A_hat[2][0]),
        .g(s_hat[0]),
        .h(result6)
    );
    multiply_ntts multiply7 (
        .f(A_hat[2][1]),
        .g(s_hat[1]),
        .h(result7)
    );
    multiply_ntts multiply8 (
        .f(A_hat[2][2]),
        .g(s_hat[2]),
        .h(result8)
    );

    always_comb begin
        // Initialize t_hat to zero
        for (int i = 0; i < 3; i++) begin
            for (int m = 0; m < 256; m++) begin
                t_hat[i][m] = 0;
            end
        end

        // Combine results to get final t_hat
        for (int m = 0; m < 256; m++) begin
            t_hat[0][m] = result0[m] + result1[m] + result2[m];
            t_hat[1][m] = result3[m] + result4[m] + result5[m];
            t_hat[2][m] = result6[m] + result7[m] + result8[m];
        end
    end

endmodule