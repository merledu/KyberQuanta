`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 09:06:34 PM
// Design Name: 
// Module Name: top_module
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
module top_module (
    // CBD module inputs
    input  logic         cbd_clk,
    input  logic         cbd_reset,
    input  logic [7:0]   cbd_input_byte_array [127:0],
    input  logic [$clog2(127):0] cbd_input_len,
    output logic signed [1:0] cbd_output_f [255:0],

    // bytes_to_bits module inputs
    input  logic [7:0]   btb_input_B [255:0],
    input  logic [$clog2(256):0] btb_input_len,
    output logic [2047:0] btb_output_b,

    // bits_to_bytes module inputs
    input  logic [2047:0] btb2_input_bit_array,
    output logic [7:0]    btb2_output_byte_array [255:0],

    // compress_module inputs
    input  logic [15:0]  compress_input_x,
    input  logic [15:0]  compress_input_d,
    output logic [15:0]  compress_output_result,

    // decompress_module inputs
    input  logic [15:0]  decompress_input_x,
    input  logic [15:0]  decompress_input_d,
    output logic [15:0]  decompress_output_result,

    // Encode module inputs/outputs
    input  logic signed [15:0] encode_input_F [255:0],
    output logic [7:0]         encode_output_B [255:0],

    // Decode module inputs/outputs
    input  logic [7:0]         decode_input_B [0:127],
    input  logic [$clog2(128):0] decode_input_len,
    output logic [11:0]        decode_output_coeffs [255:0],

    // NTT module
    input  logic               ntt_clk,
    input  logic               ntt_reset,
    input  logic               ntt_start,
    input  logic signed [1:0]  ntt_input_f [255:0],
    output logic signed [15:0] ntt_output_f_hat [255:0],
    output logic               ntt_done,

    // Inverse NTT module
    input  logic               ntt_inv_clk,
    input  logic               ntt_inv_rst,
    input  logic               ntt_inv_start,
    input  logic signed [31:0] ntt_inv_input_f [255:0],
    output logic signed [31:0] ntt_inv_output_f_hat [255:0],
    output logic               ntt_inv_done


);

    // Instantiate bytes_to_bits
    bytes_to_bits #(
        .BYTE_COUNT(256)
    ) btb_inst (
        .B   (btb_input_B),
        .len (btb_input_len),
        .b   (btb_output_b)
    );

    // Instantiate bits_to_bytes
    bits_to_bytes #(
        .BIT_LENGTH(2048)
    ) btb2_inst (
        .bit_array  (btb2_input_bit_array),
        .byte_array (btb2_output_byte_array)
    );

    // Instantiate CBD
    CBD cbd_inst (
        .clk         (cbd_clk),
        .reset       (cbd_reset),
        .byte_array  (cbd_input_byte_array),
        .len         (cbd_input_len),
        .f           (cbd_output_f)
    );

    // Instantiate compress_module
    compress_module compress_inst (
        .x      (compress_input_x),
        .d      (compress_input_d),
        .result (compress_output_result)
    );

    // Instantiate decompress_module
    decompress_module decompress_inst (
        .x      (decompress_input_x),
        .d      (decompress_input_d),
        .result (decompress_output_result)
    );

    // Instantiate encode module
    encode #(
        .D(8),
        .BYTE_LEN(32)
    ) encode_inst (
        .F(encode_input_F),
        .B(encode_output_B)
    );

    // Instantiate decode module
    decode #(
        .ELL(12),
        .NUM_COEFFS(256),
        .BYTE_COUNT(128)
    ) decode_inst (
        .byte_array(decode_input_B),
        .len(decode_input_len),
        .coeffs(decode_output_coeffs)
    );

    // Instantiate NTT
    ntt #(
        .N(256),
        .Q(3329)
    ) ntt_inst (
        .clk(ntt_clk),
        .reset(ntt_reset),
        .start(ntt_start),
        .f(ntt_input_f),
        .f_hat(ntt_output_f_hat),
        .done(ntt_done)
    );

    // Instantiate Inverse NTT
    inverse_ntt #(
        .N(256),
        .Q(3329),
        .F(3303)
    ) ntt_inv_inst (
        .clk(ntt_inv_clk),
        .rst(ntt_inv_rst),
        .start_ntt(ntt_inv_start),
        .f(ntt_inv_input_f),
        .f_hat(ntt_inv_output_f_hat),
        .done_ntt(ntt_inv_done)
    );

   

endmodule
