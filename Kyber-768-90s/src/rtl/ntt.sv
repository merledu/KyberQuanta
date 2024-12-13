`timescale 1ns / 1ps
module ntt #(parameter N = 256, parameter Q = 3329) (
    input  logic signed [15:0] f [255:0],  
    output logic signed [15:0] f_hat [255:0]
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

    integer i, j, length, start, m;
    logic signed [15:0] zeta, temp, added;

    always_comb begin
        // Initial setup
        i = 1;
        length = 128;  // Initial length for FFT-like algorithm (or other similar operation)
        
        // Copy initial values from f to f_hat
        for (int k = 0; k < N; k++) begin
            f_hat[k] = f[k];
        end
        
        // Main loop for length-based iteration, halving the length each time
        while (length >= 2) begin
            start = 0;
            
            // Process the elements in the range from start to N
            while (start < N) begin
                zeta = zetas[i];  // Fetch the next zeta value from the precomputed list
                i = i + 1;  // Increment zeta index
                
                // For each block of length "length", perform the necessary operation
                for (j = start; j < start + length; j = j + 1) begin
                    added = f_hat[j + length]; // Get the second half of the data block
                    
                    // Modular multiplication
                    temp = (zeta * added) % Q;
                    
                    // Normalize if temp is negative
                    if (temp < 0) 
                        temp = temp + Q;
                    
                    // Update f_hat with the result of the operation
                    f_hat[j + length] = (f_hat[j] - temp) % Q;
                    
                    // Normalize the result if it's negative
                    if (f_hat[j + length] < 0) 
                        f_hat[j + length] = f_hat[j + length] + Q;
                    
                    // Update f_hat[j] with the sum of the values
                    f_hat[j] = (f_hat[j] + temp) % Q;
                    
                    // Normalize the result if it's negative
                    if (f_hat[j] < 0) 
                        f_hat[j] = f_hat[j] + Q;
                end
                
                // Move the starting point forward
                start = start + length;
            end
            
            // Reduce the length for the next iteration (typical of FFT-like algorithms)
            length = length >> 1;  // Equivalent to length = length / 2
        end

        // Final normalization step for all values of f_hat
        for (m = 0; m < 256; m = m + 1) begin
            f_hat[m] = f_hat[m] % Q;
            if (f_hat[m] < 0) begin
                f_hat[m] = f_hat[m] + Q;
            end
        end
    end
endmodule
