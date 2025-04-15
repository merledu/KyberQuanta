`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:34:11 PM
// Design Name: 
// Module Name: bits_to_bytes_wrapper
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


module bits_to_bytes_wrapper #(
    parameter BIT_LENGTH = 1024,
    parameter BYTE_LENGTH = BIT_LENGTH / 8
) (
    input logic enable,
    input logic [BIT_LENGTH-1:0] bit_array,
    output logic [7:0] byte_array [BYTE_LENGTH-1:0]
);

    logic [7:0] byte_internal [BYTE_LENGTH-1:0];

    bits_to_bytes #(
        .BIT_LENGTH(BIT_LENGTH)
    ) u_bttb (
        .bit_array(bit_array),
        .byte_array(byte_internal)
    );

    always_comb begin
        for (int i = 0; i < BYTE_LENGTH; i++) begin
            byte_array[i] = enable ? byte_internal[i] : 8'd0;
        end
    end
endmodule

