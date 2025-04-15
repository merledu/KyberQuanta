`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:33:09 PM
// Design Name: 
// Module Name: bytes_to_bits_wrapper
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


module bytes_to_bits_wrapper #(
    parameter BYTE_COUNT = 128,
    parameter BIT_COUNT = BYTE_COUNT * 8
) (
    input logic enable,
    input logic [7:0] B [BYTE_COUNT-1:0],
    input logic [$clog2(BYTE_COUNT):0] len,
    output logic [BIT_COUNT-1:0] b
);

    logic [BIT_COUNT-1:0] b_internal;

    bytes_to_bits #(
        .BYTE_COUNT(BYTE_COUNT)
    ) u_btb (
        .B(B),
        .len(len),
        .b(b_internal)
    );

    always_comb begin
        b = enable ? b_internal : '0;
    end
endmodule
