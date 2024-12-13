`timescale 1ns / 1ps

module tb_encode;

    // Parameters
    parameter D = 8;
    parameter BYTE_LEN = 32;
    parameter NUM_INPUTS = 256;

    // DUT inputs and outputs
    logic signed [15:0] F [0:NUM_INPUTS-1]; // Input 16-bit signed array
    logic [7:0] B [0:BYTE_LEN * D - 1];    // Output byte array

    // Instantiate the DUT
    encode #(
        .D(D),
        .BYTE_LEN(BYTE_LEN)
    ) dut (
        .F(F),
        .B(B)
    );

    // Testbench variables
    integer i;

    initial begin
        // Initialize the input array F
        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
            F[i] = i;  // Assign each element a value (0 to 255)
        end

        // Wait for the combinational logic to propagate
        #10;

        // Display the encoded output byte array
        $display("Encoded byte array B:");
        for (i = 0; i < BYTE_LEN * D; i = i + 1) begin
            $display("B[%0d] = %0d", i, B[i]);
        end

        // Finish simulation
        $finish;
    end

endmodule
