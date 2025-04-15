`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:36:19 PM
// Design Name: 
// Module Name: decompress_wrapper
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


module decompress_wrapper (
    input logic enable,
    input logic [15:0] x,
    input logic [15:0] d,
    output logic [15:0] result
);

    logic [15:0] result_internal;

    decompress_module u_dm (
        .x(x),
        .d(d),
        .result(result_internal)
    );

    always_comb begin
        result = enable ? result_internal : 16'd0;
    end
endmodule
