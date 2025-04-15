`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:35:37 PM
// Design Name: 
// Module Name: compress_wrapper
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

module compress_wrapper (
    input logic enable,
    input logic [15:0] x,
    input logic [15:0] d,
    output logic [15:0] result
);

    logic [15:0] result_internal;

    compress_module u_cm (
        .x(x),
        .d(d),
        .result(result_internal)
    );

    always_comb begin
        result = enable ? result_internal : 16'd0;
    end
endmodule

