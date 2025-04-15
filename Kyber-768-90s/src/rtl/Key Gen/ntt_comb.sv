//`timescale 1ns / 1ps
//module ntt #(parameter N = 256, parameter Q = 3329) (
//    input  logic clk,              // Clock signal
//    input  logic reset,            // Reset signal
//    input  logic start,            // Start signal to begin computation
//    input  logic signed [15:0] f [255:0],  
//    output logic signed [15:0] f_hat [255:0],
//    output logic done              // Done signal to indicate completion
//);
//    // Initialize zetas array with given values
//    logic signed [15:0] zetas [0:127] = {
//            1, 1729, 2580, 3289, 2642, 630, 1897, 848,
//            1062, 1919, 193, 797, 2786, 3260, 569, 1746,
//            296, 2447, 1339, 1476, 3046, 56, 2240, 1333,
//            1426, 2094, 535, 2882, 2393, 2879, 1974, 821,
//            289, 331, 3253, 1756, 1197, 2304, 2277, 2055,
//            650, 1977, 2513, 632, 2865, 33, 1320, 1915,
//            2319, 1435, 807, 452, 1438, 2868, 1534, 2402,
//            2647, 2617, 1481, 648, 2474, 3110, 1227, 910,
//            17, 2761, 583, 2649, 1637, 723, 2288, 1100,
//            1409, 2662, 3281, 233, 756, 2156, 3015, 3050,
//            1703, 1651, 2789, 1789, 1847, 952, 1461, 2687,
//            939, 2308, 2437, 2388, 733, 2337, 268, 641,
//            1584, 2298, 2037, 3220, 375, 2549, 2090, 1645,
//            1063, 319, 2773, 757, 2099, 561, 2466, 2594,
//            2804, 1092, 403, 1026, 1143, 2150, 2775, 886,
//            1722, 1212, 1874, 1029, 2110, 2935, 885, 2154
// }; 

//    // State machine definition
//    typedef enum logic [2:0] {
//        IDLE,       // Wait for start signal
//        COPY,       // Copy input array to output
//        PROCESS,    // Perform NTT computation
//        NORMALIZE,  // Final normalization
//        DONE        // Computation complete
//    } state_t;

//    state_t state;

//    // Loop indices and intermediate variables
//    integer i, j, length, start_idx, k, _;
//    logic signed [15:0] zeta, temp, added;
//    logic [7:0] pairs [0:126][0:1] = '{
//                '{0, 128}, '{0, 64}, '{128, 192}, '{0, 32}, '{64, 96}, '{128, 160}, '{192, 224},
//                '{0, 16}, '{32, 48}, '{64, 80}, '{96, 112}, '{128, 144}, '{160, 176}, '{192, 208}, '{224, 240},
//                '{0, 8}, '{16, 24}, '{32, 40}, '{48, 56}, '{64, 72}, '{80, 88}, '{96, 104}, '{112, 120},
//                '{128, 136}, '{144, 152}, '{160, 168}, '{176, 184}, '{192, 200}, '{208, 216}, '{224, 232}, '{240, 248},
//                '{0, 4}, '{8, 12}, '{16, 20}, '{24, 28}, '{32, 36}, '{40, 44}, '{48, 52}, '{56, 60},
//                '{64, 68}, '{72, 76}, '{80, 84}, '{88, 92}, '{96, 100}, '{104, 108}, '{112, 116}, '{120, 124},
//                '{128, 132}, '{136, 140}, '{144, 148}, '{152, 156}, '{160, 164}, '{168, 172}, '{176, 180}, '{184, 188},
//                '{192, 196}, '{200, 204}, '{208, 212}, '{216, 220}, '{224, 228}, '{232, 236}, '{240, 244}, '{248, 252},
//                '{0, 2}, '{4, 6}, '{8, 10}, '{12, 14}, '{16, 18}, '{20, 22}, '{24, 26}, '{28, 30},
//                '{32, 34}, '{36, 38}, '{40, 42}, '{44, 46}, '{48, 50}, '{52, 54}, '{56, 58}, '{60, 62},
//                '{64, 66}, '{68, 70}, '{72, 74}, '{76, 78}, '{80, 82}, '{84, 86}, '{88, 90}, '{92, 94},
//                '{96, 98}, '{100, 102}, '{104, 106}, '{108, 110}, '{112, 114}, '{116, 118}, '{120, 122}, '{124, 126},
//                '{128, 130}, '{132, 134}, '{136, 138}, '{140, 142}, '{144, 146}, '{148, 150}, '{152, 154}, '{156, 158},
//                '{160, 162}, '{164, 166}, '{168, 170}, '{172, 174}, '{176, 178}, '{180, 182}, '{184, 186}, '{188, 190},
//                '{192, 194}, '{196, 198}, '{200, 202}, '{204, 206}, '{208, 210}, '{212, 214}, '{216, 218}, '{220, 222},
//                '{224, 226}, '{228, 230}, '{232, 234}, '{236, 238}, '{240, 242}, '{244, 246}, '{248, 250}, '{252, 254}};

//    always_ff @(posedge clk or posedge reset) begin
//        if (reset) begin
//            state <= IDLE;
//            done <= 0;
//            i <= 1;
//            length <= 128;
//            start_idx <= 0;
//        end else begin
//            case (state)
//                IDLE: begin
//                    if (start) begin
//                        state <= COPY;
//                    end
//                end

//                COPY: begin
//                    for (k = 0; k < N; k = k + 1) begin
//                        f_hat[k] <= f[k];
////                        $display("s",f[k]);
//                    end
//                    state <= PROCESS;
//                end

//                PROCESS: begin
                    
////                        if (i >= 128) begin
////                                       i = 0;
//                                       $display("i",i);
////                                   end
//                    for (_ = 0; _ < 7; _ = _ + 1) begin
//                                        for (start_idx = 0; start_idx < N; start_idx = start_idx + 2 * length) begin
//                    zeta = zetas[i];
//                    i = i + 1;
                    
////                    if (start_idx < N) begin
//                        for (k = 0; k <= 126; k = k + 1) begin
//                            if (pairs[k][0] == start_idx && pairs[k][1] == start_idx + length) begin
//                                for (j = pairs[k][0]; j < pairs[k][1]; j = j + 1) begin
//                                    if (j + length < N) begin
//                                        added = f_hat[j + length];
//                                        $display(j,length, added);
//                                        temp = (zeta * added) % Q;
////                                        $display("check",zeta);
//                                        if (temp < 0) temp = temp + Q;
                                        
//                                        f_hat[j + length] = (f_hat[j] - temp) % Q;
//                                        if (f_hat[j + length] < 0) f_hat[j + length] = f_hat[j + length] + Q;
                                        
//                                        f_hat[j] = (f_hat[j] + temp) % Q;
//                                        if (f_hat[j] < 0) f_hat[j] = f_hat[j] + Q;
                                        
                                        
//                                    end
//                                end
//                            end
//                        end
//                       end
                       
            
                   
//                        length = length >> 1;
//                        start_idx = 0;
//                        if (length < 2) begin
//                            state = NORMALIZE;
//                        end
//                    end
//               end
                

//                NORMALIZE: begin
                
//                    for (j = 0; j < N; j = j + 1) begin
                    
//                        f_hat[j] = f_hat[j] % Q;
//                        if (f_hat[j] < 0) begin
//                            f_hat[j] = f_hat[j] + Q;
//                        end
//                    end
//                    state <= DONE;
//                end

//                DONE: begin
//                    done = 1;
//                    state = IDLE;
//                end
//            endcase
//        end
//    end
//endmodule