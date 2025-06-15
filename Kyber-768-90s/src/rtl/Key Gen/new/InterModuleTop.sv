`timescale 1ns / 1ps

module top_module (
    // CBD module inputs
    input logic start_cbd,
    output logic done_cbd,
    input  logic         cbd_clk,
    input  logic         cbd_reset,
    input  logic [7:0]   cbd_input_byte_array [127:0],
    input  logic [$clog2(127):0] cbd_input_len,
    output logic signed [11:0] cbd_output_f [255:0],

    // bytes_to_bits module inputs
//    input logic [7:0] BTB_ByteCount,
//    input  logic [7:0]   btb_input_B [127:0],
//    input  logic [$clog2(256):0] btb_input_len,
//    output logic [2047:0] btb_output_b,

//    // bits_to_bytes module inputs
//    input logic [7:0] BitLen,
//    input  logic [2047:0] btb2_input_bit_array,
//    output logic [7:0]    btb2_output_byte_array [255:0],

    // compress_module inputs
    input start_compress,
    input  logic [15:0]  compress_input_x,
    input  logic [15:0]  compress_input_d,
    output logic [15:0]  compress_output_result,

    // decompress_module inputs
    input start_decompress,
    input  logic [15:0]  decompress_input_x,
    input  logic [15:0]  decompress_input_d,
    output logic [15:0]  decompress_output_result,

    // Encode module inputs/outputs
    input start_encode,
    output logic done_encode,
    input  logic signed [15:0] encode_input_F [255:0],
    output logic [7:0]         encode_output_B [255:0],

    // Decode module inputs/outputs
    input start_decode,
    input  logic [7:0]         decode_input_B [0:31],
    input  logic [$clog2(128):0] decode_input_len,
    output logic [7:0]        decode_output_coeffs [255:0],

    // NTT module
    input  logic               ntt_clk,
    input  logic               ntt_reset,
    input  logic               ntt_start,
    input  logic signed [11:0]  ntt_input_f [255:0],
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

    // ---------- Gating Logic ----------

    // Compress gating
    logic [15:0] x_compress_actual, d_compress_actual;
    always_comb begin
        if (start_compress) begin
            x_compress_actual = compress_input_x;
            d_compress_actual = compress_input_d;
        end else begin
            x_compress_actual = 16'd0;
            d_compress_actual = 16'd1;
        end
    end

    // Decompress gating
    logic [15:0] x_decompress_actual, d_decompress_actual;
    always_comb begin
        if (start_decompress) begin
            x_decompress_actual = decompress_input_x;
            d_decompress_actual = decompress_input_d;
        end else begin
            x_decompress_actual = 16'd0;
            d_decompress_actual = 16'd1;
        end
    end

    // BTB gating
//    logic [7:0] btb_input_muxed [127:0];
//    logic [$clog2(256):0] btb_len_muxed;
//    always_comb begin
//        if (BTB_ByteCount != 8'd0) begin
//            btb_input_muxed = btb_input_B;
//            btb_len_muxed = btb_input_len;
//        end else begin
//            btb_input_muxed = '{default:8'd0};
//            btb_len_muxed = 0;
//        end
//    end

    // Decode gating
    logic [7:0] decode_input_muxed [0:31];
    logic [$clog2(128):0] decode_len_muxed;
    always_comb begin
        if (start_decode) begin
            decode_input_muxed = decode_input_B;
            decode_len_muxed = decode_input_len;
        end else begin
            decode_input_muxed = '{default:8'd0};
            decode_len_muxed = 0;
        end
    end

    // ---------- Module Instantiations ----------

    // CBD
    CBD cbd_inst (
        .clk        (cbd_clk),
        .reset      (cbd_reset),
        .start      (start_cbd),
        .done       (done_cbd),
        .byte_array (cbd_input_byte_array),
        .len        (cbd_input_len),
        .f          (cbd_output_f)
    );

    // Compress
    compress_module compress_inst (
        .x      (x_compress_actual),
        .d      (d_compress_actual),
        .result (compress_output_result)
    );

    // Decompress
    decompress_module decompress_inst (
        .x      (x_decompress_actual),
        .d      (d_decompress_actual),
        .result (decompress_output_result)
    );

    // Bytes to Bits
//    bytes_to_bits #(.BYTE_COUNT(128)) btb_inst (
//        .B   (btb_input_muxed),
//        .len (btb_len_muxed),
//        .b   (btb_output_b)
//    );

//    // Bits to Bytes
//    bits_to_bytes #(.BIT_LENGTH(2048)) btb2_inst (
//        .bit_array  (btb2_input_bit_array),
//        .byte_array (btb2_output_byte_array)
//    );

    // Encode
    encode #(.D(8), .BYTE_LEN(32)) encode_inst (
        .start (start_encode),
        .done  (done_encode),
        .F     (encode_input_F),
        .B     (encode_output_B)
    );

    // Decode
    decode #(.ELL(8), .NUM_COEFFS(256)) decode_inst (
        .byte_array (decode_input_muxed),
        .len        (decode_len_muxed),
        .coeffs     (decode_output_coeffs)
    );

    // NTT
    ntt #(.N(256), .Q(3329)) ntt_inst (
        .clk    (ntt_clk),
        .reset  (ntt_reset),
        .start  (ntt_start),
        .f      (ntt_input_f),
        .f_hat  (ntt_output_f_hat),
        .done   (ntt_done)
    );

    // Inverse NTT
    inverse_ntt #(.N(256), .Q(3329), .F(3303)) ntt_inv_inst (
        .clk      (ntt_inv_clk),
        .rst      (ntt_inv_rst),
        .start_ntt(ntt_inv_start),
        .f        (ntt_inv_input_f),
        .f_hat    (ntt_inv_output_f_hat),
        .done_ntt (ntt_inv_done)
    );

endmodule
