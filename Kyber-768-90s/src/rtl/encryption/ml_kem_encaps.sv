`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 02:24:44 PM
// Design Name: 
// Module Name: ml_kem_encaps
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

module ml_kem_encaps #(
    parameter EK_WIDTH = 9472,
    parameter CT_WIDTH = 8704,
    parameter KEY_WIDTH = 256,
    parameter RANDOM_WIDTH = 256
)(
    input  logic clk,
    input  logic rst,
    input  logic start,
    input logic [7:0] ek[1183:0],             // Public key
    input logic [7:0] mess [32-1:0],     // Random 32-byte message

    output logic [KEY_WIDTH-1:0] K,             // Shared key
    output logic [7:0] c [1088-1:0],              // Ciphertext
    output logic done
 
);

    encaps_internal encaps_inst (
        .clk(clk),
        .rst(rst),
        .ek(ek),
        .mess(mess),
        .start(start),
        .K(K),
        .c(c),
        .done(done)
    );

endmodule
