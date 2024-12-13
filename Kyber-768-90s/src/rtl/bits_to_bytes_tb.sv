`timescale 1ns / 1ps

module tb_bits_to_bytes;

    // Parameters
    parameter BYTE_LENGTH = 32;                   // Number of bytes
    parameter BIT_LENGTH = BYTE_LENGTH * 8;       // Number of bits

    // DUT inputs and outputs
    logic [BIT_LENGTH-1:0] bit_array;             // Input bit array
    logic [BYTE_LENGTH-1:0] byte_array;           // Output byte array

    // Instantiate the DUT
    bits_to_bytes #(
        .BIT_LENGTH(BIT_LENGTH),
        .BYTE_LENGTH(BYTE_LENGTH)
    ) dut (
        .bit_array(bit_array),
        .byte_array(byte_array)
    );

    // Testbench variables
    integer i;

    initial begin
        // Initialize bit_array with alternating 0s and 1s
        for (i = 0; i < BIT_LENGTH; i = i + 1) begin
            bit_array[i] = (i % 2);  // Alternating bits
        end

        // Wait for combinational logic to update
        #10;

        // Display the results
        $display("Input bit_array:");
        for (i = 0; i < BIT_LENGTH; i = i + 1) begin
            $write("%b", bit_array[i]);
            if ((i + 1) % 8 == 0) $write(" ");  // Group bits into bytes
        end
        $display("\n");

        $display("Output byte_array:");
        for (i = 0; i < BYTE_LENGTH; i = i + 1) begin
            $display("B[%0d] = 0x%02X", i, byte_array[i]);
        end

        // Finish simulation
        $finish;
    end

endmodule
