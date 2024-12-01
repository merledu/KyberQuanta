`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 12:20:03 AM
// Design Name: 
// Module Name: bytes_to_bits
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



module tb_bytes_to_bits;

    // Parameters
    localparam LEN = 32;

    // Inputs to DUT
    logic [7:0] B [LEN-1:0]; // Unpacked array
    logic [7:0] len;

    // Outputs from DUT
    logic  [LEN*8-1:0] b; // Unpacked array

    // DUT instantiation
    bytes_to_bits uut (
        .B(B),
        .len(len),
        .b(b)
    );

    // Test Variables
    logic [7:0] input_array [LEN-1:0]; // Unpacked array for readability
    

    initial begin
        // Initialize inputs
        len = LEN;

        // Sample Input Data
        input_array = '{
            8'hFF, 8'h00, 8'hEF, 8'h01, 8'hFF, 8'hFF, 8'h67, 8'h89,
            8'h00, 8'hFF, 8'h55, 8'hAA, 8'h7E, 8'h5A, 8'h3C, 8'h1E,
            8'hFF, 8'h0F, 8'h33, 8'h77, 8'h11, 8'h22, 8'h44, 8'h88,
            8'h99, 8'hEE, 8'hDD, 8'hCC, 8'hBB, 8'hAA, 8'h77, 8'hFF
        };

        // Assign input values to the DUT
        for (int i = 0; i < LEN; i++) begin
            B[i] = input_array[i];
        end

        // Wait for evaluation
        #10;

      

        // Print the output bit array in the desired format
        $display("Output:");
        for (int i = 0; i < LEN * 8; i++) begin
            $write("%b, ", b[i]);
        end
        $display(""); // Newline for better formatting

       

        $display("Test Passed!");
        $finish;
    end

endmodule