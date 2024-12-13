`timescale 1ns / 1ps

module tb_Decode;

    // Parameters
    parameter ELL = 8;
    parameter NUM_COEFFS = 256;
    parameter BYTE_COUNT = 32;

    // DUT inputs and outputs
    logic [7:0] byte_array [0:BYTE_COUNT-1];
    logic [$clog2(BYTE_COUNT):0] len;
    logic [ELL-1:0] coeffs [0:NUM_COEFFS-1];

    // Instantiate the DUT
    Decode #(
        .ELL(ELL),
        .NUM_COEFFS(NUM_COEFFS),
        .BYTE_COUNT(BYTE_COUNT)
    ) dut (
        .byte_array(byte_array),
        .len(len),
        .coeffs(coeffs)
    );

    // Testbench variables
    integer i;
    reg [7:0] input_byte_array [0:BYTE_COUNT-1];
    reg [15:0] coeffs_sv [0:NUM_COEFFS-1];

    initial begin
        // Initialize the input byte array (same as in Verilator testbench)
        input_byte_array = '{
            8'h49, 8'h8B, 8'h0B, 8'hFF, 8'hFE, 8'hCE, 8'hB3, 8'hC5,
            8'h6C, 8'hE7, 8'h1E, 8'h8B, 8'hA4, 8'h6F, 8'h61, 8'hEF,
            8'h07, 8'hCD, 8'h2A, 8'hCD, 8'h46, 8'h16, 8'h58, 8'hBE,
            8'hCA, 8'hAE, 8'h59, 8'hA2, 8'h78, 8'h50, 8'hA1, 8'hA4
        };

        // Assign the input byte array to the DUT
        for (i = 0; i < BYTE_COUNT; i = i + 1) begin
            byte_array[i] = input_byte_array[i];
        end

        // Set the length of the byte array
        len = BYTE_COUNT;

        // Wait for combinational logic to propagate
        #10;

        // Print the output coefficients
        $display("Output Coefficients:");
        for (i = 0; i < NUM_COEFFS; i = i + 1) begin
            coeffs_sv[i] = coeffs[i];
            $display("Coefficient %0d: %0d", i, coeffs_sv[i]);
        end

        // Finish simulation
        $finish;
    end

endmodule
