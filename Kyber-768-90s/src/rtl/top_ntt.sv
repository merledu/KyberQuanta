`timescale 1ns / 1ps

module top_ntt #(
    parameter ARRAY_SIZE = 256,
    parameter Q = 3329
)(
    input  logic clk,
    input  logic rst,
    input  logic btn,
    output logic led
);

    logic start, done, result_ready, output_match, checked;

    logic signed [15:0] f[ARRAY_SIZE-1:0];
    logic signed [15:0] f_hat[ARRAY_SIZE-1:0];
    logic signed [15:0] expected_f_hat[ARRAY_SIZE-1:0];

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            start <= 1'b0;
        else if (btn && !done && !result_ready)
            start <= 1'b1;
        else
            start <= 1'b0;
    end

    ntt #(
        .N(ARRAY_SIZE),
        .Q(Q)
    ) ntt_inst (
        .clk(clk),
        .reset(rst),
        .start(start),
        .f(f),
        .f_hat(f_hat),
        .done(done)
    );

    initial begin
        foreach (f[i]) f[i] = 16'sd0;
        f[0] = 0;  f[1] = 1;  f[2] = 0;  f[3] = -1;
        f[4] = 0;  f[5] = 1;  f[6] = 0;  f[7] = -1;
        f[8] = 0;  f[9] = 1;  f[10] = 0; f[11] = -1;
        f[12] = 0; f[100] = -1; f[101] = 0; f[102] = 1;
        f[103] = 0; f[104] = -1; f[105] = 0; f[106] = 1;
        f[180] = -1; f[181] = 0; f[182] = 1;
        f[190] = 0; f[191] = -1;
        f[205] = 1; f[206] = 0; f[207] = -1; f[208] = 0; f[209] = 1;
        f[230] = 0; f[231] = -1; f[232] = 0;
        f[250] = -1; f[251] = 0; f[252] = 1; f[253] = 0; f[254] = 1; f[255] = -1;
    end

    initial begin
        expected_f_hat = '{
            303, 1380, 1580, 2420, 3139, 1974, 528, 2602, 476, 2561, 3063, 308, 1609, 520, 312, 1551,
            111, 291, 1264, 1037, 1775, 1410, 102, 2966, 2953, 2789, 2122, 2408, 415, 1911, 238, 504,
            331, 1789, 401, 1358, 2776, 2862, 1349, 1838, 1729, 3073, 2563, 1414, 465, 1103, 3158, 3208,
            2974, 2705, 1762, 476, 1651, 1700, 966, 3318, 240, 478, 17, 672, 865, 609, 2072, 29, 296,
            2119, 2869, 1118, 973, 1861, 657, 1515, 305, 2065, 174, 1563, 562, 752, 3122, 1559, 2714,
            2219, 784, 2555, 2577, 1785, 2102, 1337, 1631, 2034, 3203, 1464, 2403, 1391, 1891, 531, 2798,
            1422, 3011, 964, 587, 889, 2930, 1854, 556, 800, 3276, 2191, 3261, 1096, 2340, 771, 1141,
            2684, 1716, 2704, 2777, 2378, 929, 2636, 906, 146, 552, 3228, 2982, 1244, 215, 1625, 370, 99,
            709, 1815, 1286, 3172, 1276, 2326, 288, 2980, 1196, 3288, 287, 3071, 2547, 3223, 1602, 1510,
            2317, 2281, 1382, 467, 77, 373, 2386, 2196, 571, 2542, 2034, 3032, 1662, 915, 1205, 883, 336,
            1353, 1632, 1072, 2346, 3151, 1221, 2184, 2168, 3086, 708, 2875, 1870, 2041, 142, 1473, 1050,
            2598, 2322, 1240, 1870, 2531, 2879, 1316, 2530, 2112, 2545, 1366, 1824, 680, 1477, 2052, 1575,
            3223, 1910, 2524, 3226, 1056, 818, 1661, 2772, 2850, 2909, 458, 181, 2821, 850, 1697, 2389,
            400, 1728, 347, 2225, 661, 2424, 1330, 352, 1850, 2182, 3320, 2959, 382, 1711, 48, 2916, 1245,
            644, 2165, 1731, 1874, 2737, 3053, 258, 2155, 2873, 87, 736, 2689, 1317, 98, 740, 308, 1688,
            2539, 1592, 2686, 1297, 1524, 2738, 125, 2912, 722, 758, 1985
        };
    end

    // Output match checker
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            output_match <= 0;
            result_ready <= 0;
            checked <= 0;
        end else if (done && !checked) begin
            int mismatch_count = 0;
            bit local_match = 1;
            foreach (f_hat[i]) begin
                if (f_hat[i] !== expected_f_hat[i]) begin
                    local_match = 0;
                    mismatch_count++;
                end
            end
            output_match <= local_match;
            result_ready <= 1;
            checked <= 1;

            $display("[INFO] Time %0t: NTT computation complete.", $time);
            if (local_match)
                $display("[INFO] Output matches expected result.");
            else begin
                $display("[WARN] Output DOES NOT match expected result.");
                $display("[DIFF] Total mismatches: %0d", mismatch_count);
            end
        end
    end

    // LED logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            led <= 1'b0;
        else if (btn && result_ready && output_match) begin
            led <= 1'b1;
            $display("[INFO] Time %0t: Button pressed after verification - LED turned ON.", $time);
        end else if (btn && result_ready && !output_match) begin
            $display("[WARN] Time %0t: Button pressed, but output mismatch - LED remains OFF.", $time);
        end else if (btn && !result_ready) begin
            $display("[NOTE] Time %0t: Button pressed before computation finished - LED not activated.", $time);
        end
    end

endmodule
