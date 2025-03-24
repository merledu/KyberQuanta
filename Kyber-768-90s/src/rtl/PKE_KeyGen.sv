//module KeyGen(
//    output logic [255:0] rho,
//    output logic [255:0] sigma,
//    output logic [255:0] A [0:2][0:2],
//    output logic [255:0] s [0:2],
//    output logic [255:0] e [0:2],
//    output logic [255:0] t [0:2],
//    output logic [255:0] ek_PKE,
//    output logic [255:0] dk_PKE
//);
    
//    // Static input value of d
//    logic [255:0] d = 256'hf688563f7c66a5da2d8bdb5a5f3e07bd8dce6f7efcec7f41298d79863459f7cd;
    
//    // Extracted values of rho and sigma (fixed values)
//    assign rho  = 256'h26ffff11b531b1800f4e1fa75c4d008c4f9a112932c669d543551204405da8b4;
//    assign sigma = 256'h6de0c01beda8a2ba3f697c1bb8d5a46dc2ac63880c4f9b57db9f10534cef9a42;
    
//    // SampleNTT module instantiations for k = 3
//    SampleNTT sampleNTT_00 (.input_data({rho, 8'h00, 8'h00}), .output_data(A[0][0]));
//    SampleNTT sampleNTT_01 (.input_data({rho, 8'h00, 8'h01}), .output_data(A[0][1]));
//    SampleNTT sampleNTT_02 (.input_data({rho, 8'h00, 8'h02}), .output_data(A[0][2]));
    
//    SampleNTT sampleNTT_10 (.input_data({rho, 8'h01, 8'h00}), .output_data(A[1][0]));
//    SampleNTT sampleNTT_11 (.input_data({rho, 8'h01, 8'h01}), .output_data(A[1][1]));
//    SampleNTT sampleNTT_12 (.input_data({rho, 8'h01, 8'h02}), .output_data(A[1][2]));
    
//    SampleNTT sampleNTT_20 (.input_data({rho, 8'h02, 8'h00}), .output_data(A[2][0]));
//    SampleNTT sampleNTT_21 (.input_data({rho, 8'h02, 8'h01}), .output_data(A[2][1]));
//    SampleNTT sampleNTT_22 (.input_data({rho, 8'h02, 8'h02}), .output_data(A[2][2]));
    
//    // PRF module instantiations
//    logic [255:0] prf_out_s [0:2];
//    logic [255:0] prf_out_e [0:2];

//    PRF prf_s0 (.sigma(sigma), .nonce(8'h00), .output_data(prf_out_s[0]));
//    PRF prf_s1 (.sigma(sigma), .nonce(8'h01), .output_data(prf_out_s[1]));
//    PRF prf_s2 (.sigma(sigma), .nonce(8'h02), .output_data(prf_out_s[2]));

//    PRF prf_e0 (.sigma(sigma), .nonce(8'h03), .output_data(prf_out_e[0]));
//    PRF prf_e1 (.sigma(sigma), .nonce(8'h04), .output_data(prf_out_e[1]));
//    PRF prf_e2 (.sigma(sigma), .nonce(8'h05), .output_data(prf_out_e[2]));

//    // Sampling s and e using PRF outputs
//    SamplePolyCBD sampleCBD_s0 (.input_data(prf_out_s[0]), .output_data(s[0]));
//    SamplePolyCBD sampleCBD_s1 (.input_data(prf_out_s[1]), .output_data(s[1]));
//    SamplePolyCBD sampleCBD_s2 (.input_data(prf_out_s[2]), .output_data(s[2]));

//    SamplePolyCBD sampleCBD_e0 (.input_data(prf_out_e[0]), .output_data(e[0]));
//    SamplePolyCBD sampleCBD_e1 (.input_data(prf_out_e[1]), .output_data(e[1]));
//    SamplePolyCBD sampleCBD_e2 (.input_data(prf_out_e[2]), .output_data(e[2]));

//    // NTT Transformation
//    logic [255:0] s_ntt [0:2];
//    logic [255:0] e_ntt [0:2];
    
//    NTT ntt_s0 (.input_data(s[0]), .output_data(s_ntt[0]));
//    NTT ntt_s1 (.input_data(s[1]), .output_data(s_ntt[1]));
//    NTT ntt_s2 (.input_data(s[2]), .output_data(s_ntt[2]));
    
//    NTT ntt_e0 (.input_data(e[0]), .output_data(e_ntt[0]));
//    NTT ntt_e1 (.input_data(e[1]), .output_data(e_ntt[1]));
//    NTT ntt_e2 (.input_data(e[2]), .output_data(e_ntt[2]));
    
//    // Compute t = A * s + e using MultiplyNTT
//    logic [255:0] mult_out_00, mult_out_01, mult_out_02;
//    logic [255:0] mult_out_10, mult_out_11, mult_out_12;
//    logic [255:0] mult_out_20, mult_out_21, mult_out_22;

//    MultiplyNTT mul_00 (.a(A[0][0]), .b(s_ntt[0]), .out(mult_out_00));
//    MultiplyNTT mul_01 (.a(A[0][1]), .b(s_ntt[1]), .out(mult_out_01));
//    MultiplyNTT mul_02 (.a(A[0][2]), .b(s_ntt[2]), .out(mult_out_02));

//    MultiplyNTT mul_10 (.a(A[1][0]), .b(s_ntt[0]), .out(mult_out_10));
//    MultiplyNTT mul_11 (.a(A[1][1]), .b(s_ntt[1]), .out(mult_out_11));
//    MultiplyNTT mul_12 (.a(A[1][2]), .b(s_ntt[2]), .out(mult_out_12));

//    MultiplyNTT mul_20 (.a(A[2][0]), .b(s_ntt[0]), .out(mult_out_20));
//    MultiplyNTT mul_21 (.a(A[2][1]), .b(s_ntt[1]), .out(mult_out_21));
//    MultiplyNTT mul_22 (.a(A[2][2]), .b(s_ntt[2]), .out(mult_out_22));

//    // Accumulate results manually
//    assign t[0] = mult_out_00 + mult_out_01 + mult_out_02 + e_ntt[0];
//    assign t[1] = mult_out_10 + mult_out_11 + mult_out_12 + e_ntt[1];
//    assign t[2] = mult_out_20 + mult_out_21 + mult_out_22 + e_ntt[2];

//    // Byte Encoding
////    ByteEncode_12 enc_t (.input_data(t), .output_data(ek_PKE));
//        // Byte Encoding for ek_PKE (each index is 384 bytes)
//    logic [3071:0] ek_PKE_parts [0:2]; // 384 bytes (3072 bits) per index

//    ByteEncode_12 enc_t0 (.input_data(t[0]), .output_data(ek_PKE_parts[0]));
//    ByteEncode_12 enc_t1 (.input_data(t[1]), .output_data(ek_PKE_parts[1]));
//    ByteEncode_12 enc_t2 (.input_data(t[2]), .output_data(ek_PKE_parts[2]));

//    assign ek_PKE = {ek_PKE_parts[0], ek_PKE_parts[1], ek_PKE_parts[2], rho};  // Concatenation

//    logic [3071:0] sk_SKE_parts [0:2]; // 384 bytes (3072 bits) per index

//    ByteEncode_12 enc_s0 (.input_data(s_ntt[0]), .output_data(sk_SKE_parts[0]));
//    ByteEncode_12 enc_s1 (.input_data(s_ntt[1]), .output_data(sk_SKE_parts[1]));
//    ByteEncode_12 enc_s2 (.input_data(s_ntt[2]), .output_data(sk_SKE_parts[2]));

//    assign sk_PKE = {sk_SKE_parts[0], sk_SKE_parts[1], sk_SKE_parts[2]};

//endmodule