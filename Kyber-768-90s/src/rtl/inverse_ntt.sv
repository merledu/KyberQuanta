`timescale 1ns / 1ps
module inverse_ntt #(parameter N = 256, parameter Q = 3329, parameter F = 3303) (
    input  logic signed [31:0] f [255:0], 
    output logic signed [31:0] f_hat [255:0] 
);

    integer signed i, j, length, start;  
    logic signed [15:0] zeta;
    logic signed [15:0] temp; 
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
 

    always_comb begin
        for (i = 0; i < N; i = i + 1) begin
            f_hat[i] = f[i];
        end

        i = 127;  
        length = 2;
        while (length <= 128) begin 
            start = 0;
            while (start < N) begin 
                zeta = zetas[i];
                i = i - 1;
                for (j = start; j < start + length; j = j + 1) begin
                    temp = f_hat[j];
                    f_hat[j] = (temp + f_hat[j + length]) % Q ;
                    f_hat[j + length] = (f_hat[j + length] - temp) % Q ;
                    f_hat[j + length] = (zeta * f_hat[j + length]) % Q;
                    if (f_hat[j + length] < 0)
                        f_hat[j + length] = f_hat[j + length] + Q;
                end
                start = start + 2 * length;
                
            end
            length = length << 1;
            
        end
        for (j = 0; j < N; j = j + 1) begin
            f_hat[j] = (f_hat[j] * F) % Q;
            if (f_hat[j] == Q - 1) 
                f_hat[j] = -1;
        end
    end
endmodule