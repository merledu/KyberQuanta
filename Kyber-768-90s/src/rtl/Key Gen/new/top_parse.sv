`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 01:11:30 AM
// Design Name: 
// Module Name: top_parse
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
    logic [7:0]  B [WORD_COUNT_IN-1:0];
    logic [15:0] a [WORD_COUNT_OUT-1:0];
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
            B[k] = k%255;
        end
    end

    // Expected output array as provided.
    // The values below are given as 12-bit decimal constants.
    localparam logic [15:0] expected_a [0:WORD_COUNT_OUT-1] = '{
         16'd256, 16'd32, 16'd1027, 16'd80, 16'd1798, 16'd128, 16'd2569, 16'd176,
       16'd224, 16'd15, 16'd273, 16'd786, 16'd321, 16'd1557, 16'd369, 16'd2328,
       16'd417, 16'd3099, 16'd465, 16'd513, 16'd545, 16'd562, 16'd1316, 16'd610,
       16'd2087, 16'd658, 16'd2858, 16'd706, 16'd754, 16'd304, 16'd803, 16'd1075,
       16'd851, 16'd1846, 16'd899, 16'd2617, 16'd947, 16'd995, 16'd63, 16'd1044,
       16'd834, 16'd1092, 16'd1605, 16'd1140, 16'd2376, 16'd1188, 16'd3147, 16'd1236,
       16'd1284, 16'd593, 16'd1333, 16'd1364, 16'd1381, 16'd2135, 16'd1429, 16'd2906,
       16'd1477, 16'd1525, 16'd352, 16'd1574, 16'd1123, 16'd1622, 16'd1894, 16'd1670,
       16'd2665, 16'd1718, 16'd1766, 16'd111, 16'd1815, 16'd882, 16'd1863, 16'd1653,
       16'd1911, 16'd2424, 16'd1959, 16'd3195, 16'd2007, 16'd2055, 16'd641, 16'd2104,
       16'd1412, 16'd2152, 16'd2183, 16'd2200, 16'd2954, 16'd2248, 16'd2296, 16'd400,
       16'd2345, 16'd1171, 16'd2393, 16'd1942, 16'd2441, 16'd2713, 16'd2489, 16'd2537,
       16'd159, 16'd2586, 16'd930, 16'd2634, 16'd1701, 16'd2682, 16'd2472, 16'd2730,
       16'd3243, 16'd2778, 16'd2826, 16'd689, 16'd2875, 16'd1460, 16'd2923, 16'd2231,
       16'd2971, 16'd3002, 16'd3019, 16'd3067, 16'd448, 16'd3116, 16'd1219, 16'd3164,
       16'd1990, 16'd3212, 16'd2761, 16'd3260, 16'd3308, 16'd207, 16'd978, 16'd1749,
       16'd2520, 16'd3291, 16'd737, 16'd1508, 16'd2279, 16'd3050, 16'd496, 16'd1267,
       16'd2038, 16'd2809, 16'd256, 16'd32, 16'd1027, 16'd80, 16'd1798, 16'd128,
       16'd2569, 16'd176, 16'd224, 16'd15, 16'd273, 16'd786, 16'd321, 16'd1557,
       16'd369, 16'd2328, 16'd417, 16'd3099, 16'd465, 16'd513, 16'd545, 16'd562,
       16'd1316, 16'd610, 16'd2087, 16'd658, 16'd2858, 16'd706, 16'd754, 16'd304,
       16'd803, 16'd1075, 16'd851, 16'd1846, 16'd899, 16'd2617, 16'd947, 16'd995,
       16'd63, 16'd1044, 16'd834, 16'd1092, 16'd1605, 16'd1140, 16'd2376, 16'd1188,
       16'd3147, 16'd1236, 16'd1284, 16'd593, 16'd1333, 16'd1364, 16'd1381, 16'd2135,
       16'd1429, 16'd2906, 16'd1477, 16'd1525, 16'd352, 16'd1574, 16'd1123, 16'd1622,
       16'd1894, 16'd1670, 16'd2665, 16'd1718, 16'd1766, 16'd111, 16'd1815, 16'd882,
       16'd1863, 16'd1653, 16'd1911, 16'd2424, 16'd1959, 16'd3195, 16'd2007, 16'd2055,
       16'd641, 16'd2104, 16'd1412, 16'd2152, 16'd2183, 16'd2200, 16'd2954, 16'd2248,
       16'd2296, 16'd400, 16'd2345, 16'd1171, 16'd2393, 16'd1942, 16'd2441, 16'd2713,
       16'd2489, 16'd2537, 16'd159, 16'd2586, 16'd930, 16'd2634, 16'd1701, 16'd2682,
       16'd2472, 16'd2730, 16'd3243, 16'd2778, 16'd2826, 16'd689, 16'd2875, 16'd1460,
       16'd2923, 16'd2231, 16'd2971, 16'd3002, 16'd3019, 16'd3067, 16'd448, 16'd3116
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