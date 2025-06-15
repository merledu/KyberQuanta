`timescale 1ns / 1ps
module CBD (
    input logic start,
    output logic done,
    input  logic         clk,           // Clock input
    input  logic         reset,         // Synchronous reset
    input  logic [7:0]   byte_array [127:0], // 256-element array of 8-bit bytes
    input  logic [$clog2(127):0] len,    // Length (should be 256)
    output logic [11:0] f [255:0]   // 256-element array of signed outputs with wider bit width
);

    // Convert the byte_array into a 2048-bit vector using your verified bytes_to_bits module.
    // Each byte becomes 8 bits (positions 8*i to 8*i+7).
     logic processing;
//       logic done_reg;
    logic [1023:0] bit_array;
    logic [255:0] done_array;
    assign done = &done_array;
    int temp;

    bytes_to_bits #(
        .BYTE_COUNT(128)
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
                    f[i] <= 12'sd0;
                else if (start) begin
                int x, y;
                    // Convert the corresponding bits into x and y
                    x = 0;
                    y = 0;
                    // Summing bits for x
                    for (int j = 0; j < 2; j = j + 1) begin
                        x = x + bit_array[2 * i * 2 + j];
                    end
                    // Summing bits for y
                    for (int j = 0; j < 2; j = j + 1) begin
                        y = y + bit_array[2 * i * 2 + 2 + j];
                    end
                    // Display for debugging purposes
                    $display("x = %0d, y = %0d, x - y = %0d", x, y, x - y);

                    // Perform modulo operation and assign the result
                    
                    temp = (x - y);
                    if (temp < 0)
                        f[i] = temp + 3329;
                    else
                        f[i] = temp;
                    done_array[i] = 1'b1;
                    // Optional: Add checks for overflow if needed (for larger ranges)
                    
                end
                
            end
            
        end
    endgenerate
        

endmodule
