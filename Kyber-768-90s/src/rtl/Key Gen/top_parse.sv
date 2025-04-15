`timescale 1ns/1ps
module top_parse (
    input  logic clk,    // system clock
    input  logic rst,    // active high reset
    input  logic btn,    // push-button; when pressed, generates a start pulse and later triggers verification
    output logic led     // LED indicates successful output verification on button press
);

    // Parameters for array sizes
    localparam WORD_COUNT_IN  = 768;   // number of 10-bit words in B
    localparam WORD_COUNT_OUT = 256;   // number of 12-bit words in a

    // Input and output arrays for the parse module
    logic [9:0]  B [0:WORD_COUNT_IN-1];
    logic [11:0] a [0:WORD_COUNT_OUT-1];
    logic done;
    logic start;

    // Instantiate the parse module.
    parse parse_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .B(B),
        .done(done),
        .a(a)
    );

    // Generate a one-clock-cycle start pulse when the button is pressed.
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            start <= 1'b0;
        else if (btn)
            start <= 1'b1;
        else
            start <= 1'b0;
    end

    // Initialize the input array B with a known pattern (B[k] = k).
    initial begin
        for (int k = 0; k < WORD_COUNT_IN; k++) begin
            B[k] = k;
        end
    end

    // Expected output array as provided.
    // The values below are given as 12-bit decimal constants.
    localparam logic [11:0] expected_a [0:WORD_COUNT_OUT-1] = '{
         12'd256,  12'd32,   12'd1027,  12'd80,   12'd1798,  12'd128,  12'd2569,  12'd176,
         12'd224,  12'd15,   12'd273,   12'd786,  12'd321,   12'd1557, 12'd369,   12'd2328,
         12'd417,  12'd3099, 12'd465,   12'd513,  12'd545,   12'd562,  12'd1316,  12'd610,
         12'd2087, 12'd658,  12'd2858, 12'd706,  12'd754,   12'd304,  12'd803,   12'd1075,
         12'd851,  12'd1846, 12'd899,   12'd2617, 12'd947,   12'd995,  12'd63,    12'd1044,
         12'd834,  12'd1092, 12'd1605, 12'd1140, 12'd2376,  12'd1188, 12'd3147,  12'd1236,
         12'd1284, 12'd593,  12'd1333, 12'd1364, 12'd1381,  12'd2135, 12'd1429,  12'd2906,
         12'd1477, 12'd1525, 12'd352,   12'd1574, 12'd1123,  12'd1622, 12'd1894,  12'd1670,
         12'd2665, 12'd1718, 12'd1766, 12'd111,  12'd1815,  12'd882,  12'd1863,  12'd1653,
         12'd1911, 12'd2424, 12'd1959, 12'd3195, 12'd2007, 12'd2055, 12'd641,   12'd2104,
         12'd1412, 12'd2152, 12'd2183, 12'd2200, 12'd2954, 12'd2248, 12'd2296,  12'd400,
         12'd2345, 12'd1171, 12'd2393, 12'd1942, 12'd2441, 12'd2713, 12'd2489,  12'd2537,
         12'd159,  12'd2586, 12'd930,   12'd2634, 12'd1701, 12'd2682, 12'd2472,  12'd2730,
         12'd3243, 12'd2778, 12'd2826, 12'd689,  12'd2875, 12'd1460, 12'd2923,  12'd2231,
         12'd2971, 12'd3002, 12'd3019, 12'd3067, 12'd448,  12'd3116, 12'd1219,  12'd3164,
         12'd1990, 12'd3212, 12'd2761, 12'd3260, 12'd3308, 12'd207,  12'd978,   12'd1749,
         12'd2520, 12'd3291, 12'd737,  12'd1508, 12'd2279, 12'd3050, 12'd496,   12'd1267,
         12'd2038, 12'd2809, 12'd255,  12'd1026, 12'd1797, 12'd2568, 12'd785,   12'd1556,
         12'd2327, 12'd3098, 12'd544,  12'd1315, 12'd2086, 12'd2857, 12'd303,   12'd1074,
         12'd1845, 12'd2616, 12'd833,  12'd1604, 12'd2375, 12'd3146, 12'd592,   12'd1363,
         12'd2134, 12'd2905, 12'd351,  12'd1122, 12'd1893, 12'd2664, 12'd881,   12'd1652,
         12'd2423, 12'd3194, 12'd640,  12'd1411, 12'd2182, 12'd2953, 12'd399,   12'd1170,
         12'd1941, 12'd2712, 12'd929,  12'd1700, 12'd2471, 12'd3242, 12'd688,   12'd1459,
         12'd2230, 12'd3001, 12'd447,  12'd1218, 12'd1989, 12'd2760, 12'd977,   12'd1748,
         12'd2519, 12'd3290, 12'd736,  12'd1507, 12'd2278, 12'd3049, 12'd495,   12'd1266,
         12'd2037, 12'd2808, 12'd1025, 12'd1796, 12'd2567, 12'd784,  12'd1555,  12'd2326,
         12'd3097, 12'd543,  12'd1314, 12'd2085, 12'd2856, 12'd1073, 12'd1844,  12'd2615,
         12'd832,  12'd1603, 12'd2374, 12'd3145, 12'd591,  12'd1362, 12'd2133,  12'd2904,
         12'd1121, 12'd1892, 12'd2663, 12'd880,  12'd1651, 12'd2422, 12'd3193,  12'd639,
         12'd1410, 12'd2181, 12'd2952, 12'd1169, 12'd1940, 12'd2711, 12'd928,   12'd1699,
         12'd2470, 12'd3241, 12'd687,  12'd1458, 12'd2229, 12'd3000, 12'd1217, 12'd1988,
         12'd2759, 12'd976,  12'd1747, 12'd2518, 12'd3289, 12'd735,  12'd1506,  12'd2277
    };

    // Verification: Check that every output word equals the expected value.
    logic valid_output;
    integer idx;
    always_comb begin
        valid_output = 1'b1;
        for (idx = 0; idx < WORD_COUNT_OUT; idx++) begin
            if (a[idx] !== expected_a[idx])
                valid_output = 1'b0;
        end
    end

    // Drive the LED: When the button is pressed, update LED to 1 if the parse module is done
    // and the output matches the expected result.
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            led <= 1'b0;
        else if (btn)
            led <= (done && valid_output);
    end

endmodule