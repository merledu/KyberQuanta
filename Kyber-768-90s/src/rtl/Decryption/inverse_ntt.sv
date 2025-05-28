`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:15:58 PM
// Design Name: 
// Module Name: inverse_ntt
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



module inverse_ntt # (
    parameter N = 256, // Polynomial length
    parameter Q = 3329, // Modulus
    parameter F = 3303 // Final scaling factor
)
(
    input logic clk,
    input logic rst,
    input logic signed [31:0] f [N-1:0], // Input polynomial in NTT domain
    input logic start_ntt, // Start signal
    output logic done_ntt, // Done signal
    output logic signed [31:0] f_hat [N-1:0] // Output polynomial
);

    // ----------------------------------------------------------
    // Correct Twiddle factors for Inverse NTT:
    // zetas[i] = 17^( bit_reversal(i,7) ) mod 3329, i=0..127
    // Then used in descending order (i_zeta=127 down to 0).
    // ----------------------------------------------------------
    logic signed [15:0] zetas [0:127] = '{
        1, 1729, 2580, 3289, 2642, 630, 1897, 848,
        1062, 1919, 193, 797, 2786, 3260, 569, 1746,
        296, 2447, 1339, 1476, 3046, 56, 2240, 1333,
        1426, 2094, 535, 2882, 2393, 2879, 1974, 821,
        289, 331, 3253, 1756, 1197, 2304, 2277, 2055,
        650, 1977, 2513, 632, 2865, 33, 1320, 1915,
        2319, 1435, 807, 452, 1438, 2868, 1534, 2402,
        2647, 2617, 1481, 648, 2474, 3110, 1227, 910,
        17, 2761, 583, 2649, 1637, 723, 2288, 1100,
        1409, 2662, 3281, 233, 756, 2156, 3015, 3050,
        1703, 1651, 2789, 1789, 1847, 952, 1461, 2687,
        939, 2308, 2437, 2388, 733, 2337, 268, 641,
        1584, 2298, 2037, 3220, 375, 2549, 2090, 1645,
        1063, 319, 2773, 757, 2099, 561, 2466, 2594,
        2804, 1092, 403, 1026, 1143, 2150, 2775, 886,
        1722, 1212, 1874, 1029, 2110, 2935, 885, 2154
    };

    // ----------------------------------------------------------
    // State Machine
    // ----------------------------------------------------------
    typedef enum logic [3:0] {
        S_IDLE, // Wait for start signal
        S_COPY, // Copy input to internal register
        S_INIT, // Initialize counters
        S_START, // Start butterfly operation
        S_BUTTERFLY, // Perform butterfly operation
        S_INCR_START, // Increment start position
        S_INCR_LENGTH, // Double length and reset start
        S_FINAL_MUL, // Final multiplication by F
        S_DONE // Operation complete
    } state_t;

    state_t current_state, next_state;

    // Internal counters, registers
    logic [8:0] length_reg; // Current length (l in Python)
    logic [8:0] start_reg; // Current start position
    logic [8:0] j_reg; // Current j position
    logic [7:0] i_zeta; // Current zeta index
    logic signed [15:0] cur_zeta; // Current zeta value
    logic signed [31:0] temp; // Temporary value for butterfly
    logic [8:0] mul_idx; // Index for final multiplication

    // ----------------------------------------------------------
    // 1) FSM: current_state register
    // ----------------------------------------------------------
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S_IDLE;
        else
            current_state <= next_state;
    end

    // ----------------------------------------------------------
    // 2) FSM: next_state logic (combinational)
    // ----------------------------------------------------------
    always_comb begin
        next_state = current_state;
        case (current_state)
            S_IDLE: begin
                if (start_ntt)
                    next_state = S_COPY;
            end

            S_COPY: begin
                next_state = S_INIT;
            end

            S_INIT: begin
                next_state = S_START;
            end

            S_START: begin
                next_state = S_BUTTERFLY;
            end

            S_BUTTERFLY: begin
                if (j_reg < (start_reg + length_reg - 1))
                    next_state = S_BUTTERFLY;
                else
                    next_state = S_INCR_START;
            end

            S_INCR_START: begin
                if ((start_reg + (2 * length_reg)) < N)
                    next_state = S_START;
                else
                    next_state = S_INCR_LENGTH;
            end

            S_INCR_LENGTH: begin
                if ((length_reg << 1) <= 128)
                    next_state = S_START;
                else
                    next_state = S_FINAL_MUL;
            end

            S_FINAL_MUL: begin
                if (mul_idx == (N-1))
                    next_state = S_DONE;
                else
                    next_state = S_FINAL_MUL;
            end

            S_DONE: begin
                next_state = S_DONE;
            end

            default: next_state = S_IDLE;
        endcase
    end

    // ----------------------------------------------------------
    // 3) Datapath + Control
    // ----------------------------------------------------------
    integer k;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            done_ntt <= 1'b0;
            for (k = 0; k < N; k++) f_hat[k] <= 0;

            length_reg <= 9'd0;
            start_reg <= 9'd0;
            j_reg <= 9'd0;
            i_zeta <= 8'd127;
            cur_zeta <= 16'd0;
            mul_idx <= 9'd0;

        end else begin
            case (current_state)

                // S_IDLE: just wait
                S_IDLE: begin
                    done_ntt <= 1'b0; 
                end

                // S_COPY: copy input f[] -> f_hat[]
                S_COPY: begin
                    for (k = 0; k < N; k++) begin
                        f_hat[k] <= f[k];

                    end
                end

                // S_INIT: set counters
                S_INIT: begin
                    length_reg <= 9'd2;
                    i_zeta <= 8'd127;
                    start_reg <= 9'd0;
                    j_reg <= 9'd0;
                end

                // S_START: pick up zeta = zetas[i_zeta], decrement i_zeta
                S_START: begin
                    cur_zeta <= zetas[i_zeta];
                    i_zeta <= i_zeta - 1;
                    j_reg <= start_reg;
                end

                // S_BUTTERFLY: do one butterfly iteration
                S_BUTTERFLY: begin
                    logic signed [31:0] diff;
                   
                    temp = f_hat[j_reg];
                    // First operation: f_hat[j_reg] = (t + f_hat[j_reg + length_reg]) mod Q
                    f_hat[j_reg] <= (temp + f_hat[j_reg + length_reg] >= Q) 
                                      ? (temp + f_hat[j_reg + length_reg] - Q)
                                      : (temp + f_hat[j_reg + length_reg]);

                    // Second operation: f_hat[j_reg + length_reg] = (f_hat[j_reg + length_reg] - temp) mod Q
                    diff = (f_hat[j_reg + length_reg] >= temp)
                                                 ? (f_hat[j_reg + length_reg] - temp)
                                                 : (f_hat[j_reg + length_reg] + Q - temp);

                    // Third operation: f_hat[j_reg + length_reg] = (zeta * diff) mod Q
                    diff = (cur_zeta * diff) % Q;
                    

                    f_hat[j_reg + length_reg] <= diff;

                    // Increment j
                    j_reg <= j_reg + 1;
                end

                // S_INCR_START: move to next block
                S_INCR_START: begin
                    start_reg <= start_reg + (2 * length_reg);
                end

                // S_INCR_LENGTH: double length, reset start
                S_INCR_LENGTH: begin
                    length_reg <= length_reg << 1;
                    start_reg <= 9'd0;
                end

                // S_FINAL_MUL: multiply each coeff by F = 3303 mod 3329
                // and map 3328 -> -1
                S_FINAL_MUL: begin
                    logic signed [31:0] tmpval;
                    tmpval = (f_hat[mul_idx] * F) % Q;
                    if (tmpval == (Q - 1))
                        f_hat[mul_idx] <= -1;
                    else
                        f_hat[mul_idx] <= tmpval;

                    if (mul_idx == (N-1)) 
                        mul_idx <= 0;
                    else
                        mul_idx <= mul_idx + 1;
                end

                // S_DONE: indicate we are finished
                S_DONE: begin
                    done_ntt <= 1'b1;
                end

            endcase
        end
    end

endmodule
