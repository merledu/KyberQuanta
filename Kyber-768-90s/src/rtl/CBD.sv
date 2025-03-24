`timescale 1ns / 1ps
module CBD (
    input  logic         clk,           // Clock input
    input  logic         reset,         // Synchronous reset
    input  logic [7:0]   byte_array [0:255], // 256-element array of 8-bit bytes
    input  logic [$clog2(256):0] len,    // Length (should be 256)
    output logic signed [1:0] f [0:255]   // 256-element array of 2-bit signed outputs
);

    // Convert the byte_array into a 2048-bit vector using your verified bytes_to_bits module.
    // Each byte becomes 8 bits (positions 8*i to 8*i+7).
    logic [2047:0] bit_array;

    bytes_to_bits #(
        .BYTE_COUNT(256)
    ) btb (
        .B(byte_array),
        .len(len),
        .b(bit_array)
    );
    generate
        genvar i;
        for (i = 0; i < 256; i = i + 1) begin : gen_f
            always_ff @(posedge clk) begin
                if (reset)
                    f[i] <= 2'sd0;
                else
                    f[i] <= {1'b0, bit_array[4 * i]} - {1'b0, bit_array[4 * i + 2]};            end
        end
    endgenerate

endmodule
