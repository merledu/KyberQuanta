`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:34:59 PM
// Design Name: 
// Module Name: CBD_wrapper
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


module CBD_wrapper (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [7:0] byte_array [127:0],
    input  logic [$clog2(127):0] len,
    output logic signed [1:0] f [255:0]
);

    logic signed [1:0] f_internal [255:0];

    CBD cbd_core (
        .clk(clk),
        .reset(reset),
        .byte_array(byte_array),
        .len(len),
        .f(f_internal)
    );

    always_comb begin
        for (int i = 0; i < 256; i++) begin
            f[i] = enable ? f_internal[i] : 2'sd0;
        end
    end
endmodule

