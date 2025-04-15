`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 10:39:18 PM
// Design Name: 
// Module Name: top_module_tb
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


module top_module_tb;

    // Clock and Reset
    logic clk;
    logic reset;

    // Select signal to choose which module to activate
    logic [4:0] select;

    // Inputs for bytes_to_bits
    logic [7:0] btb_input_B [255:0];
    logic [$clog2(256):0] btb_input_len;
    logic [2047:0] btb_output_b;

    // Inputs for bits_to_bytes
    logic [2047:0] btb2_input_bit_array;
    logic [7:0] btb2_output_byte_array [255:0];

    // Inputs for CBD
    logic [7:0] cbd_input_byte_array [127:0];
    logic [$clog2(127):0] cbd_input_len;
    logic signed [1:0] cbd_output_f [255:0];

    // Inputs for compress_module
    logic [15:0] compress_input_x;
    logic [15:0] compress_input_d;
    logic [15:0] compress_output_result;

    // Inputs for decompress_module
    logic [15:0] decompress_input_x;
    logic [15:0] decompress_input_d;
    logic [15:0] decompress_output_result;
    
       // Inputs/Outputs for encode module
     logic signed [15:0] encode_input_F [255:0];
     logic [7:0] encode_output_B [255:0];
 
     // Inputs/Outputs for decode module
     logic [7:0] decode_input_B [127:0];
     logic [$clog2(128):0] decode_input_len;
     logic [11:0] decode_output_coeffs [255:0];
     
      // Inputs/Outputs for NTT
        logic ntt_clk;
        logic ntt_reset;
        logic ntt_start;
        logic signed [1:0] ntt_input_f [255:0];
        logic signed [15:0] ntt_output_f_hat [255:0];
        logic ntt_done;
    
        // Inputs/Outputs for Inverse NTT
        logic ntt_inv_clk;
        logic ntt_inv_rst;
        logic ntt_inv_start;
        logic signed [31:0] ntt_inv_input_f [255:0];
        logic signed [31:0] ntt_inv_output_f_hat [255:0];
        logic ntt_inv_done;
    
      // Clock generation
        initial begin
            clk = 0;
            ntt_clk = 0;
            ntt_inv_clk = 0;
          end
      
          always #5 clk = ~clk;
          always #7 ntt_clk = ~ntt_clk;
          always #11 ntt_inv_clk = ~ntt_inv_clk;
    

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Module instantiations
    top_module dut (
        .cbd_clk(clk),
        .cbd_reset(reset),
        .cbd_input_byte_array(cbd_input_byte_array),
        .cbd_input_len(cbd_input_len),
        .cbd_output_f(cbd_output_f),
        .btb_input_B(btb_input_B),
        .btb_input_len(btb_input_len),
        .btb_output_b(btb_output_b),
        .btb2_input_bit_array(btb2_input_bit_array),
        .btb2_output_byte_array(btb2_output_byte_array),
        .compress_input_x(compress_input_x),
        .compress_input_d(compress_input_d),
        .compress_output_result(compress_output_result),
        .decompress_input_x(decompress_input_x),
        .decompress_input_d(decompress_input_d),
        .decompress_output_result(decompress_output_result),
        .encode_input_F(encode_input_F),
        .encode_output_B(encode_output_B),
        .decode_input_B(decode_input_B),
        .decode_input_len(decode_input_len),
        .decode_output_coeffs(decode_output_coeffs),
        .ntt_clk(ntt_clk),
                .ntt_reset(ntt_reset),
                .ntt_start(ntt_start),
                .ntt_input_f(ntt_input_f),
                .ntt_output_f_hat(ntt_output_f_hat),
                .ntt_done(ntt_done),
                .ntt_inv_clk(ntt_inv_clk),
                .ntt_inv_rst(ntt_inv_rst),
                .ntt_inv_start(ntt_inv_start),
                .ntt_inv_input_f(ntt_inv_input_f),
                .ntt_inv_output_f_hat(ntt_inv_output_f_hat),
                .ntt_inv_done(ntt_inv_done)
    );

    // Test scenarios
   initial begin
        // Initialize
        reset = 1;
        select = 5'b01000; // Change this to test a specific module
        #10;
        reset = 0;
    
        // Set default values for all inputs first
        btb_input_B = '{default:8'h00};
        btb_input_len = 0;
        btb2_input_bit_array = 2048'd0;
        cbd_input_byte_array = '{default:8'h00};
        cbd_input_len = 0;
        compress_input_x = 16'd0;
        compress_input_d = 16'd0;
        decompress_input_x = 16'd0;
        decompress_input_d = 16'd0;
        for (int i = 0; i < 256; i++) encode_input_F[i] = 0;
        decode_input_len = 0;
        decode_input_B = '{default:8'h00};
        ntt_start = 0;
        ntt_inv_start = 0;
    
        // Now only provide input to selected module
        case (select)
            5'b00001: begin // bytes_to_bits
                btb_input_len = 8'd4;
                for (int i = 0; i < 256; i++) begin
                    btb_input_B[i] = (i < 4) ? 8'hA5 : 8'h00;
                end
            end
            5'b00010: begin // bits_to_bytes
                btb2_input_bit_array = 2048'hFF00FF00FF00FF00;
            end
            5'b00011: begin // CBD
                cbd_input_len = 7'd4;
                for (int i = 0; i < 128; i++) begin
                    cbd_input_byte_array[i] = (i < 4) ? 8'h3C : 8'h00;
                end
            end
            5'b00100: begin // compress
                compress_input_x = 16'd1234;
                compress_input_d = 16'd4;
            end
            5'b00101: begin // decompress
                decompress_input_x = 16'd5678;
                decompress_input_d = 16'd4;
            end
            5'b00110: begin // encode
                for (int i = 0; i < 256; i++) begin
                    encode_input_F[i] = (i % 2 == 0) ? -16'sd1 : 16'sd1;
                end
            end
            5'b00111: begin // decode
                decode_input_len = 8'd8;
                for (int i = 0; i < 128; i++) begin
                    decode_input_B[i] = (i < 8) ? 8'h55 : 8'h00;
                end
            end
            5'b01000: begin // NTT
                            #20;
                            ntt_start = 1;
                            #10;
                            ntt_start = 0;
                            wait(ntt_done);
                            $display("NTT completed.");
                        end
                        5'b01001: begin // Inverse NTT
                            #20;
                            ntt_inv_start = 1;
                            #10;
                            ntt_inv_start = 0;
                            wait(ntt_inv_done);
                            $display("Inverse NTT completed.");
                        end
              
        endcase
    
        // Let it run for full simulation
        #200; // adjust if needed depending on the module latency
        $finish;
    end


endmodule
