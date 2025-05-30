`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2025 06:41:44 PM
// Design Name: 
// Module Name: decode_tb
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

module decode_tb;

    // Parameters
    parameter ELL = 12;
    parameter NUM_COEFFS = 256;
    parameter BYTE_COUNT = 32 * ELL / 8;  // Total bytes (32 * 12 / 8 = 48 bytes)

    // DUT Signals
    logic [7:0] byte_array [0:BYTE_COUNT-1];
    logic [$clog2(BYTE_COUNT):0] len;
    logic [ELL-1:0] coeffs [0:NUM_COEFFS-1];

    // Instantiate the DUT
    decode #(
        .ELL(ELL),
        .NUM_COEFFS(NUM_COEFFS),
        .BYTE_COUNT(BYTE_COUNT)
    ) dut (
        .byte_array(byte_array),
        .len(len),
        .coeffs(coeffs)
    );

    integer i;

    initial begin
        // Initialize the byte array (as given in Python)
        byte_array[0]  = 8'h49; byte_array[1]  = 8'h8B; byte_array[2]  = 8'h0B; byte_array[3]  = 8'hFF;
        byte_array[4]  = 8'hFE; byte_array[5]  = 8'hCE; byte_array[6]  = 8'hB3; byte_array[7]  = 8'hC5;
        byte_array[8]  = 8'h6C; byte_array[9]  = 8'hE7; byte_array[10] = 8'h1E; byte_array[11] = 8'h8B;
        byte_array[12] = 8'hA4; byte_array[13] = 8'h6F; byte_array[14] = 8'h61; byte_array[15] = 8'hEF;
        byte_array[16] = 8'h07; byte_array[17] = 8'hCD; byte_array[18] = 8'h2A; byte_array[19] = 8'hCD;
        byte_array[20] = 8'h46; byte_array[21] = 8'h16; byte_array[22] = 8'h58; byte_array[23] = 8'hBE;
        byte_array[24] = 8'hCA; byte_array[25] = 8'hAE; byte_array[26] = 8'h59; byte_array[27] = 8'hA2;
        byte_array[28] = 8'h78; byte_array[29] = 8'h50; byte_array[30] = 8'hA1; byte_array[31] = 8'hA4;

        // Extend with zeros to match BYTE_COUNT
        for (i = 32; i < BYTE_COUNT; i++) begin
            byte_array[i] = 8'h00;
        end

        // Set valid byte length
        len = BYTE_COUNT;

        // Wait for combinational logic to settle
        #10;

        // Display the computed coefficients
        $display("Computed Coefficients:");
        for (i = 0; i < NUM_COEFFS; i++) begin
            $display("coeffs[%0d] = %0d", i, coeffs[i]);
        end

        // Finish simulation
        $finish;
    end

endmodule
