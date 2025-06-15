`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/17/2025 03:28:00 AM
// Design Name: 
// Module Name: top_CBD
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

module top_CBD (
    input logic clk,
    input logic rst,
    input logic btn,
    output logic led
);

    localparam BYTE_COUNT = 128; // Match CBD's expectation (128 bytes)
    localparam COEFF_COUNT = 256;

    logic [7:0] byte_array [BYTE_COUNT-1:0];
    logic [$clog2(BYTE_COUNT):0] len;
    logic [11:0] f [COEFF_COUNT-1:0];  // Match CBD's f output width
    logic [11:0] expected_f [0:COEFF_COUNT-1]; // Match output size
    logic output_match;

    logic start;
    logic done;

    // Byte input initialization (unchanged)
 initial begin
           byte_array = '{
            181, 14, 115, 105, 23, 248, 168, 209, 122, 212, 86, 34, 70, 163, 19, 96, 174, 44, 141, 208, 97, 87, 204, 191, 119, 185, 247, 146, 8, 178, 97, 84, 241, 117, 241, 16, 248, 81, 164, 226, 254, 59, 155, 238, 125, 79, 119, 164, 124, 90, 150, 153, 189, 143, 136, 6, 246, 177, 24, 34, 136, 155, 251, 138, 66, 62, 87, 246, 92, 13, 206, 65, 46, 14, 224, 191, 99, 89, 36, 230, 154, 151, 65, 240, 125, 120, 31, 212, 112, 45, 242, 188, 119, 5, 105, 232, 102, 147, 79, 51, 30, 116, 148, 87, 199, 222, 164, 229, 11, 190, 91, 97, 174, 1, 22, 163, 251, 154, 54, 213, 214, 187, 55, 154, 2, 142, 223, 93
         };
           
           // Initialize expected output f array
           expected_f = '{
              3328, 0, 0, 3328, 3328, 3328, 1, 0,
               0, 0, 1, 2, 1, 1, 0, 3328,
               0, 3328, 0, 2, 0, 0, 1, 0,
               2, 0, 0, 1, 1, 0, 3328, 0,
               1, 0, 1, 0, 3328, 1, 1, 0,
               0, 3328, 3328, 0, 3328, 3328, 1, 3327,
               1, 0, 3328, 0, 3328, 1, 3328, 1,
               2, 2, 0, 3328, 2, 0, 0, 0,
               3328, 3328, 0, 0, 0, 0, 1, 1,
               3327, 1, 1, 0, 3328, 1, 0, 1,
               3328, 3328, 0, 1, 3328, 1, 3328, 1,
               0, 0, 1, 3328, 1, 0, 0, 0,
               0, 3328, 3328, 1, 0, 0, 2, 0,
               0, 1, 0, 3328, 3328, 0, 3328, 1,
               1, 3328, 3328, 3327, 3328, 0, 3327, 0,
               0, 0, 1, 0, 3328, 2, 1, 3328,
               0, 3328, 1, 0, 1, 0, 3328, 3328,
               1, 1, 3328, 1, 1, 1, 0, 0,
               0, 0, 3328, 3328, 0, 3328, 3328, 1,
               0, 0, 0, 0, 0, 0, 3327, 1,
               3328, 0, 1, 1, 0, 3328, 3328, 1,
               3328, 3328, 1, 0, 1, 2, 3328, 0,
               1, 3328, 3328, 0, 1, 0, 3328, 0,
               0, 1, 1, 0, 0, 1, 1, 0,
               3328, 0, 1, 0, 1, 1, 3328, 0,
               1, 0, 1, 0, 0, 1, 1, 1,
               0, 1, 3327, 3327, 1, 0, 1, 0,
               0, 3328, 3328, 3328, 3327, 1, 3328, 0,
               0, 0, 2, 1, 2, 0, 0, 3328,
               1, 1, 0, 0, 3328, 3328, 0, 1,
               1, 3328, 3328, 0, 3328, 0, 1, 1,
               0, 0, 2, 1, 3328, 0, 0, 1
           };
       end

    assign len = BYTE_COUNT;

    // Instantiate the CBD module
    CBD cbd_inst (
        .clk(clk),
        .reset(rst),
        .start(start),
        .done(done),
        .byte_array(byte_array),
        .len(len),
        .f(f)
    );

    // Handle button press: one-cycle pulse for start
//    logic btn_prev;
//    always_ff @(posedge clk) begin
//        if (rst)
//            btn_prev <= 0;
//        else
//            btn_prev <= btn;
//    end
assign btn = 1;
    assign start = 1; // rising edge

    // Compare outputs after CBD is done
    always_comb begin
        output_match = 1'b1;
        if (done) begin
            for (int i = 0; i < COEFF_COUNT; i++) begin
                if (f[i] !== expected_f[i])
                    output_match = 1'b0;
            end
        end
    end

    // Set LED based on match after done
    always_ff @(posedge clk) begin
        if (rst)
            led <= 1'b0;
        else if (done)
            led <= output_match;
    end

endmodule