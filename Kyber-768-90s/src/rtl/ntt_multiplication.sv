module multiply_ntts(
    input logic [15:0] f [255:0],
    input logic [15:0] g [255:0],   
    input logic [15:0] q,          
    output logic [15:0] h [255:0]    
);

    logic [15:0] zetas [127:0] = '{
        2285, 933, 2478, 2455, 344, 2191, 1848, 1089,
        1857, 694, 1300, 3101, 1180, 105, 1805, 165,
        2133, 3240, 1979, 1710, 196, 1176, 240, 1324,
        2176, 2640, 555, 788, 2787, 1233, 445, 3022,
        1896, 2141, 1057, 2231, 1224, 412, 1983, 199,
        2361, 1005, 1797, 132, 233, 2941, 3095, 1468,
        3062, 1835, 1704, 729, 2461, 271, 2395, 1165,
        524, 113, 2973, 2147, 251, 3057, 771, 3059,
        1350, 1187, 1512, 2183, 253, 2037, 1994, 2557,
        1971, 3111, 193, 2167, 3085, 1585, 3086, 3082,
        2898, 1787, 1326, 808, 3128, 1259, 2225, 2038,
        116, 182, 2929, 1376, 1494, 1284, 2491, 1715,
        264, 1840, 2302, 2044, 336, 1501, 1152, 3158,
        1245, 1727, 2565, 1385, 3080, 2202, 566, 2584,
        1042, 2483, 1303, 313, 1775, 2421, 1729, 1383,
        1091, 2105, 1508, 1713, 2468, 1238, 2470, 1491
    };

    genvar j;
    generate
        for (j = 0; j < 128; j = j + 1) begin : base_mult

            logic [15:0] a0, a1, b0, b1, gamma, c0, c1;

            assign a0 = f[2 * j];
            assign a1 = f[2 * j + 1];
            assign b0 = g[2 * j];
            assign b1 = g[2 * j + 1];
            assign gamma = zetas[j];

            // Instantiate base_case_multiply for each pair
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
                h[2 * j] = c0;
                h[2 * j + 1] = c1;
            end
        end
    endgenerate
endmodule