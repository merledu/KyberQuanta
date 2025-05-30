`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:13:26 PM
// Design Name: 
// Module Name: ntt
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


module ntt #(parameter N = 256, parameter Q = 3329) (
    input logic clk,
    input logic reset,
    input logic start,
    input logic signed [15:0] f [255:0],  
    output logic signed [15:0] f_hat [255:0],
    output logic done
);
    // Initialize zetas array with given values
    logic signed [15:0] zetas [0:127] = {
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

    // State machine definition
    typedef enum logic [3:0] {
        IDLE,
        COPY,
        LAYER_INIT,
        START_IDX_INIT,
        BUTTERFLY_PREP,
        BUTTERFLY_OP,
        LAYER_UPDATE,
        NORMALIZE,
        DONE
    } state_t;

    state_t state;

    // Counters and control signals
    logic [8:0] copy_counter;
    logic [3:0] layer_counter;
    logic [8:0] start_idx;
    logic [8:0] j;
    logic [7:0] k;
    logic [8:0] length;
    logic [7:0] zeta_idx;
    
    // Intermediate values
    logic signed [31:0] zeta;  // Extended to handle multiplication
    logic signed [31:0] temp;  // Extended to handle multiplication
    logic signed [31:0] t, u;  // For butterfly computation
    
    // Function for modular reduction
    function automatic logic signed [15:0] mod_reduce;
        input logic signed [31:0] a;
        logic signed [31:0] t;
        begin
            t = a;
            
            // First handle negative numbers
            if (t < 0) begin
                t = t + (((-t + Q - 1) / Q + 1) * Q);
            end
            
            // Now t is positive, reduce modulo Q
            t = t % Q;
            
            // Ensure output is in [0, Q-1]
            if (t >= Q) begin
                t = t - Q;
            end
            
            mod_reduce = t[15:0];
        end
    endfunction

    // Pairs array remains the same
    logic [7:0] pairs [0:126][0:1] = '{
        '{0, 128}, '{0, 64}, '{128, 192}, '{0, 32}, '{64, 96}, '{128, 160}, '{192, 224},
        '{0, 16}, '{32, 48}, '{64, 80}, '{96, 112}, '{128, 144}, '{160, 176}, '{192, 208}, '{224, 240},
        '{0, 8}, '{16, 24}, '{32, 40}, '{48, 56}, '{64, 72}, '{80, 88}, '{96, 104}, '{112, 120},
        '{128, 136}, '{144, 152}, '{160, 168}, '{176, 184}, '{192, 200}, '{208, 216}, '{224, 232}, '{240, 248},
        '{0, 4}, '{8, 12}, '{16, 20}, '{24, 28}, '{32, 36}, '{40, 44}, '{48, 52}, '{56, 60},
        '{64, 68}, '{72, 76}, '{80, 84}, '{88, 92}, '{96, 100}, '{104, 108}, '{112, 116}, '{120, 124},
        '{128, 132}, '{136, 140}, '{144, 148}, '{152, 156}, '{160, 164}, '{168, 172}, '{176, 178}, '{184, 188},
        '{192, 196}, '{200, 204}, '{208, 212}, '{216, 220}, '{224, 228}, '{232, 236}, '{240, 244}, '{248, 252},
        '{0, 2}, '{4, 6}, '{8, 10}, '{12, 14}, '{16, 18}, '{20, 22}, '{24, 26}, '{28, 30},
        '{32, 34}, '{36, 38}, '{40, 42}, '{44, 46}, '{48, 50}, '{52, 54}, '{56, 58}, '{60, 62},
        '{64, 66}, '{68, 70}, '{72, 74}, '{76, 78}, '{80, 82}, '{84, 86}, '{88, 90}, '{92, 94},
        '{96, 98}, '{100, 102}, '{104, 106}, '{108, 110}, '{112, 114}, '{116, 118}, '{120, 122}, '{124, 126},
        '{128, 130}, '{132, 134}, '{136, 138}, '{140, 142}, '{144, 146}, '{148, 150}, '{152, 154}, '{156, 158},
        '{160, 162}, '{164, 166}, '{168, 170}, '{172, 174}, '{176, 178}, '{180, 182}, '{184, 186}, '{188, 190},
        '{192, 194}, '{196, 198}, '{200, 202}, '{204, 206}, '{208, 210}, '{212, 214}, '{216, 218}, '{220, 222},
        '{224, 226}, '{228, 230}, '{232, 234}, '{236, 238}, '{240, 242}, '{244, 246}, '{248, 250}, '{252, 254}
    };

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 0;
            copy_counter <= 0;
            layer_counter <= 0;
            start_idx <= 0;
            j <= 0;
            k <= 0;
            length <= 128;
            zeta_idx <= 0;
            zeta <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= COPY;
                        copy_counter <= 0;
                    end
                end

                COPY: begin
                    if (copy_counter < N) begin
                        f_hat[copy_counter] <= f[copy_counter];
                        copy_counter <= copy_counter + 1;
                    end else begin
                        state <= LAYER_INIT;
                        layer_counter <= 0;
                        length <= 128;
                    end
                end

                LAYER_INIT: begin
                    if (layer_counter < 7) begin
                        start_idx <= 0;
                        state <= START_IDX_INIT;
                    end else begin
                        state <= NORMALIZE;
                        j <= 0;
                    end
                end

                START_IDX_INIT: begin
                    if (start_idx < N) begin
                        zeta <= zetas[zeta_idx];
                        zeta_idx <= zeta_idx + 1;
                        k <= 0;
                        state <= BUTTERFLY_PREP;
                    end else begin
                        length <= length >> 1;
                        layer_counter <= layer_counter + 1;
                        state <= LAYER_INIT;
                    end
                end

                BUTTERFLY_PREP: begin
                    if (k <= 126) begin
                        if (pairs[k][0] == start_idx && pairs[k][1] == start_idx + length) begin
                            j <= pairs[k][0];
                            state <= BUTTERFLY_OP;
                        end else begin
                            k <= k + 1;
                        end
                    end else begin
                        start_idx <= start_idx + 2 * length;
                        state <= START_IDX_INIT;
                    end
                end

                BUTTERFLY_OP: begin
                    if (j < pairs[k][1] && (j + length) < N) begin
                        // Load values
                        t = f_hat[j];
                        u = f_hat[j + length];
                        
                        // Get zeta value and compute zeta * u (mod q)
                        zeta = zetas[zeta_idx];
                        temp = mod_reduce(zeta * u);
                        
                        // Update f_hat[j + length]
                        f_hat[j + length] <= mod_reduce(t - temp);
                        
                        // Update f_hat[j]
                        f_hat[j] <= mod_reduce(t + temp);
                        
                        j <= j + 1;
                    end else begin
                        k <= k + 1;
                        state <= BUTTERFLY_PREP;
                    end
                end

                NORMALIZE: begin
                    if (j < N) begin
                        f_hat[j] <= mod_reduce(f_hat[j]);
                        j <= j + 1;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule