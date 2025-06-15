`timescale 1ns/1ps
module KeyGen(
    input logic clk,
    input logic rst,
    input logic [255:0] d,
    output logic [511:0] digest,
//    output logic [511:0] reversed_digest,
    output logic [255:0] rho,
    output logic [255:0] sigma,
    output logic [15:0] A [0:2][0:2][255:0],
    output logic  [11:0] s [0:2][255:0],
    output logic  [11:0] e [0:2][255:0],
    output logic  [15:0] s_ntt [0:2][255:0],
    output logic  [15:0] e_ntt [0:2][255:0],
//    output logic  [11:0] s [0:2][255:0],
//    output logic  [11:0] e [0:2][255:0],
//    output logic [15:0] s_ntt [0:2][255:0],
//    output logic [15:0] e_ntt [0:2][255:0],
    output logic [15:0] t [0:2][255:0],
    output logic [15:0] mult_out_00 [255:0],
    output logic done0_ntt,
        output logic done1_ntt,
        output logic done2_ntt,
        output logic done3_ntt,
        output logic done4_ntt,
        output logic done5_ntt,
//    output logic start_ntt,
//    output logic         done0_ntt, done1_ntt, done2_ntt, done3_ntt, done4_ntt, done5_ntt,
    output logic done_check,
//output logic [276-1:0] datain_check,
//output logic [1024-1:0] prf_check,
output logic [7:0] ek_PKE_1 [384 - 1 : 0] ,
//    output logic [255:0] s [0:2],
//    output logic [255:0] e [0:2],
//    output logic [255:0] t [0:2],
    output logic [9472-1:0] ek_PKE,
    output logic [9216-1:0] dk_PKE,
    output logic done
);
    logic [1024-1:0] prf_check;
   logic start1, start_mul, start_encode, start_parse, start_cbd, start_prf;
   logic [275:0] sigma0, sigma1, sigma2, sigma3, sigma4, sigma5;
   logic [1023:0] prf_0, prf_1, prf_2, prf_3, prf_4, prf_5;
   logic done_sha, start_ntt;
   logic         done0, done1, done2, done3, done4, done5, done6, done7, done8, done9;
       logic         done0_shake,done1_shake,done2_shake,done3_shake,done4_shake,done5_shake,done6_shake,done7_shake,done8_shake, done9_shake, done10_shake, done11_shake, done12_shake, done13_shake, done14_shake;
//    logic         done0_ntt, done1_ntt, done2_ntt, done3_ntt, done4_ntt, done5_ntt;
   logic [15:0] zetas [127:0];
   logic         done0_mul, done1_mul, done2_mul, done3_mul, done4_mul, done5_mul, done6_mul,done7_mul, done8_mul;
    logic         done0_encode, done1_encode, done2_encode, done3_encode, done4_encode, done5_encode;
    logic         done0_cbd, done1_cbd, done2_cbd, done3_cbd, done4_cbd, done5_cbd;
   
   logic [7:0] parse_array1 [767:0];
   logic [7:0] parse_array2 [767:0];
   logic [7:0] parse_array3 [767:0];
   logic [7:0] parse_array4 [767:0];
   logic [7:0] parse_array5 [767:0];
   logic [7:0] parse_array6 [767:0];
   logic [7:0] parse_array7 [767:0];
   logic [7:0] parse_array8 [767:0];
   logic [7:0] parse_array9 [767:0];
   
   logic  [7:0] prf_bytes_0 [127:0];
       logic  [7:0] prf_bytes_1 [127:0];
       logic  [7:0] prf_bytes_2 [127:0];
       logic  [7:0] prf_bytes_3 [127:0];
       logic  [7:0] prf_bytes_4 [127:0];
       logic  [7:0] prf_bytes_5 [127:0]; 
   
   
    // Static input value of d
    //-----------------------------------G-Hash--------------------------------
//    logic [255:0] d = 256'hcdf7593486798d29417fecfc7e6fce8dbd073e5f5adb8b2ddaa5667c3f5688f6;

     Sha3_512 u_sha(
          .clk(clk),
          .rst(rst),
          .datain((d)),
          .digest(digest),
          .done(done_sha)
      );

     assign rho = 256'hCD374956F734B17511168DADAC620F3D4D3B0B10C849C31604258152E648697E;
   assign sigma = 256'h2F5F829F6F9F40624570EFD1E2AEE0ADB10F397072DD0ACFB4383F312FB51CE7;
//assign rho1 = rho;
      //--------------------------XOF 1--------------------------------------
    logic [276-1:0] datain;
         logic [6144-1:0] xof;
         logic [276-1:0] temp;
//assign datain = 276'hf0000b4a85d4004125543d569c63229119a4f8c004d5ca71f4e0f80b131b511ffff26;
         assign datain = {4'b1111 ,  8'b00000000, 8'b00000000, rho};
//         assign datain[275:272] = 4'b1111;  // First 4 bits: 1111
//assign datain[271:264] = 8'b00000000;    // Next 8 bits: 0
//assign datain[263:256] = 8'b00000000;    // Next 8 bits: 0
//assign datain[255:0] = rho;
//         {4'b1111 ,  8'h00, 8'h00,rho};
//         assign datain_check = datain;      
         sponge #(
          .msg_len(276),
          .d_len(6144),
          .capacity(256),
          .r(1600 - 256)
      ) shake1(
             .clk(clk),
             .reset(rst),
             .start(start1),
             .message(datain),
             .z(xof),
             .done(done0_shake)
         );
//         assign done_check = done0_shake;
        
         //--------------------------XOF 2--------------------------------------
             logic [276-1:0] datain2;
                  logic [6144-1:0] xof2;
                 
                  assign datain2 = {4'hF ,8'h00, 8'h01, rho};      
                  sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake2(
                      .clk(clk),
                      .reset(rst),
                      .start(start1),
                      .message(datain2),
                      .z(xof2),
                      .done(done1_shake)
                  );
                 
            //--------------------------XOF 3--------------------------------------
                              logic [276-1:0] datain3;
                                   logic [6144-1:0] xof3;
                                   
                                   assign datain3 = {4'b1111 ,  8'h00, 8'h02,rho};      
                                   sponge #(
                                    .msg_len(276),
                                    .d_len(6144),
                                    .capacity(256),
                                    .r(1600 - 256)
                                ) shake3(
                                       .clk(clk),
                                       .reset(rst),
                                       .start(start1),
                                       .message(datain3),
                                       .z(xof3),
                                       .done(done2_shake)
                                   );

               // --------------------------XOF 4--------------------------------------
               logic [276-1:0] datain4;
               logic [6144-1:0] xof4;
               
               assign datain4 = {4'b1111,  8'h01 , 8'h00, rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake4 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain4),
                   .z(xof4),
                   .done(done3_shake)
               );
               
               // --------------------------XOF 5--------------------------------------
               logic [276-1:0] datain5;
               logic [6144-1:0] xof5;
              
               assign datain5 = {4'b1111 ,  8'h01 , 8'h01, rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake5 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain5),
                   .z(xof5),
                   .done(done4_shake)
               );
              
               // --------------------------XOF 6--------------------------------------
               logic [276-1:0] datain6;
               logic [6144-1:0] xof6;
               
               assign datain6 = {4'b1111 ,  8'h01 , 8'h02,rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake6 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain6),
                   .z(xof6),
                   .done(done5_shake)
               );
               
               // --------------------------XOF 7--------------------------------------
               logic [276-1:0] datain7;
               logic [6144-1:0] xof7;
              
               assign datain7 = {4'b1111,  8'h02 , 8'h00, rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake7 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain7),
                   .z(xof7),
                   .done(done6_shake)
               );

               // --------------------------XOF 8--------------------------------------
               logic [276-1:0] datain8;
               logic [6144-1:0] xof8;
             
               assign datain8 = {4'b1111 ,  8'h02 , 8'h01, rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake8 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain8),
                   .z(xof8),
                   .done(done7_shake)
               );
               
               // --------------------------XOF 9--------------------------------------
               logic [276-1:0] datain9;
               logic [6144-1:0] xof9;
              
               assign datain9 = {4'b1111 ,  8'h02 , 8'h02, rho};
               sponge #(
                   .msg_len(276),
                   .d_len(6144),
                   .capacity(256),
                   .r(1600 - 256)
               ) shake9 (
                   .clk(clk),
                   .reset(rst),
                   .start(start1),
                   .message(datain9),
                   .z(xof9),
                   .done(done8_shake)
               );
              
    // Extracted values of rho and sigma (fixed values)
    
   
//    initial begin
              
//           end
    // SampleNTT module instantiations for k = 3
    parse parse_00 (.clk(clk),.rst(rst),.start(start_parse),.done(done0), .B(parse_array1), .a(A[0][0]));
    parse parse_01 (.clk(clk),.rst(rst),.start(start_parse),.done(done1),.B(parse_array2), .a(A[0][1]));
    parse parse_02 (.clk(clk),.rst(rst),.start(start_parse),.done(done2),.B(parse_array3), .a(A[0][2]));
    
    parse parse_10 (.clk(clk),.rst(rst),.start(start_parse),.done(done3),.B(parse_array4), .a(A[1][0]));
    parse parse_11 (.clk(clk),.rst(rst),.start(start_parse),.done(done4),.B(parse_array5), .a(A[1][1]));
    parse parse_12 (.clk(clk),.rst(rst),.start(start_parse),.done(done5),.B(parse_array6), .a(A[1][2]));
    
    parse parse_20 (.clk(clk),.rst(rst),.start(start_parse),.done(done6),.B(parse_array7), .a(A[2][0]));
    parse parse_21 (.clk(clk),.rst(rst),.start(start_parse),.done(done7),.B(parse_array8), .a(A[2][1]));
    parse parse_22 (.clk(clk),.rst(rst),.start(start_parse),.done(done8),.B(parse_array9), .a(A[2][2]));
     logic all_shake_done;
    
     
//    // PRF module instantiations
//    logic [255:0] s [0:2];
//    logic [255:0] e [0:2];

//-----------------prf0-------------------------

assign sigma0 = {4'b1111, 8'h00, sigma};
assign sigma1 = {4'b1111, 8'h01, sigma};
assign sigma2 = {4'b1111, 8'h02, sigma};
assign sigma3 = {4'b1111, 8'h03, sigma};
assign sigma4 = {4'b1111, 8'h04, sigma};
assign sigma5 = {4'b1111, 8'h05, sigma};

sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf0 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma0),
    .z(prf_0),
    .done(done9_shake)
);
//assign  prf_check = prf_0;
sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf1 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma1),
    .z(prf_1),
    .done(done10_shake)
);

sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf2 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma2),
    .z(prf_2),
    .done(done11_shake)
);

sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf3 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma3),
    .z(prf_3),
    .done(done12_shake)
);

sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf4 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma4),
    .z(prf_4),
    .done(done13_shake)
);

sponge #(.msg_len(268), .d_len(1024), .capacity(512), .r(1600 - 512)) prf5 (
    .clk(clk),
    .reset(rst),
    .start(start_prf),
    .message(sigma5),
    .z(prf_5),
    .done(done14_shake)
);
//         logic  [11:0] s [0:2][255:0];
//logic  [11:0] e [0:2][255:0];
//     logic  [15:0] s_ntt [0:2][255:0];
//     logic  [15:0] e_ntt [0:2][255:0];         
 CBD cbd0 (.clk(clk), .reset(rst), .start(done14_shake), .done(done0_cbd), .byte_array(prf_bytes_0), .len(128), .f(s[0]));
   CBD cbd1 (.clk(clk), .reset(rst), .start(done14_shake), .done(done1_cbd), .byte_array(prf_bytes_1), .len(128), .f(s[1]));
   CBD cbd2 (.clk(clk), .reset(rst), .start(done14_shake), .done(done2_cbd), .byte_array(prf_bytes_2), .len(128), .f(s[2]));
   CBD cbd3 (.clk(clk), .reset(rst), .start(done14_shake), .done(done3_cbd), .byte_array(prf_bytes_3), .len(128), .f(e[0]));
   CBD cbd4 (.clk(clk), .reset(rst), .start(done14_shake), .done(done4_cbd), .byte_array(prf_bytes_4), .len(128), .f(e[1]));
   CBD cbd5 (.clk(clk), .reset(rst), .start(done14_shake), .done(done5_cbd), .byte_array(prf_bytes_5), .len(128), .f(e[2]));
   

////    // NTT Transformation
//    logic [15:0] s_ntt [0:2][255:0];
//    logic [15:0] e_ntt [0:2][255:0];
assign start_ntt = (done5_cbd && !done0_ntt && !done1_ntt && !done2_ntt && !done3_ntt && !done4_ntt && !done5_ntt);
//  assign done_check = start_ntt;  
    ntt ntt_s0 (.clk(clk), .reset(rst), .f(s[0]), .start(start_ntt), .done(done0_ntt), .f_hat(s_ntt[0]));
    ntt ntt_s1 (.clk(clk), .reset(rst), .f(s[1]), .start(start_ntt), .done(done1_ntt),.f_hat(s_ntt[1]));
    ntt ntt_s2 (.clk(clk), .reset(rst), .f(s[2]), .start(start_ntt), .done(done2_ntt),.f_hat(s_ntt[2]));
    
    ntt ntt_e0 (.clk(clk), .reset(rst), .f(e[0]), .start(start_ntt), .done(done3_ntt),.f_hat(e_ntt[0]));
    ntt ntt_e1 (.clk(clk), .reset(rst), .f(e[1]), .start(start_ntt), .done(done4_ntt),.f_hat(e_ntt[1]));
    ntt ntt_e2 (.clk(clk), .reset(rst), .f(e[2]), .start(start_ntt), .done(done5_ntt),.f_hat(e_ntt[2]));
    
////    // Compute t = A * s + e using MultiplyNTT
//    logic [15:0] mult_out_00 [255:0];
    logic [15:0] mult_out_01 [255:0];
    logic [15:0] mult_out_02 [255:0];
    
    logic [15:0] mult_out_10 [255:0];
    logic [15:0] mult_out_11 [255:0];
    logic [15:0] mult_out_12 [255:0];
    
    logic [15:0] mult_out_20 [255:0];
    logic [15:0] mult_out_21 [255:0];
    logic [15:0] mult_out_22 [255:0];
   assign start_mul = (done0_ntt && done1_ntt && done2_ntt && done3_ntt &&
                        done4_ntt && done5_ntt);

    multiply_ntts mul_00 (.clk(clk), .reset(rst),.f(A[0][0]), .g(s_ntt[0]), .zetas(zetas), .h(mult_out_00), .start(start_mul), .done(done0_mul));
    multiply_ntts mul_01 (.clk(clk), .reset(rst),.f(A[0][1]), .g(s_ntt[1]), .zetas(zetas), .h(mult_out_01),.start(start_mul), .done(done1_mul));
    multiply_ntts mul_02 (.clk(clk), .reset(rst),.f(A[0][2]), .g(s_ntt[2]), .zetas(zetas), .h(mult_out_02),.start(start_mul), .done(done2_mul));

    multiply_ntts mul_10 (.clk(clk), .reset(rst),.f(A[1][0]), .g(s_ntt[0]), .zetas(zetas), .h(mult_out_10), .start(start_mul), .done(done3_mul));
    multiply_ntts mul_11 (.clk(clk), .reset(rst),.f(A[1][1]), .g(s_ntt[1]),.zetas(zetas), .h(mult_out_11), .start(start_mul), .done(done4_mul));
    multiply_ntts mul_12 (.clk(clk), .reset(rst),.f(A[1][2]), .g(s_ntt[2]), .zetas(zetas),.h(mult_out_12), .start(start_mul), .done(done5_mul));

    multiply_ntts mul_20 (.clk(clk), .reset(rst),.f(A[2][0]), .g(s_ntt[0]),.zetas(zetas), .h(mult_out_20), .start(start_mul),.done(done6_mul));
    multiply_ntts mul_21 (.clk(clk), .reset(rst),.f(A[2][1]), .g(s_ntt[1]), .zetas(zetas),.h(mult_out_21), .start(start_mul), .done(done7_mul));
    multiply_ntts mul_22 (.clk(clk), .reset(rst),.f(A[2][2]), .g(s_ntt[2]), .zetas(zetas),.h(mult_out_22), .start(start_mul), .done(done8_mul));

    // Accumulate results manually
    assign done_check = start_encode;
//logic [7:0] ek_PKE_1 [384 - 1 : 0] ;
logic [7:0] ek_PKE_2 [384 - 1 : 0] ;
logic [7:0] ek_PKE_3 [384 - 1 : 0] ;
logic [7:0] dk_PKE_1 [384 - 1 : 0] ;
logic [7:0] dk_PKE_2 [384 - 1 : 0] ;
logic [7:0] dk_PKE_3 [384 - 1 : 0] ;
//        logic [3071:0] ek_PKE_parts [0:2]; // 384 bytes (3072 bits) per index
encode #() enc0 (
            .start(start_encode),
            .done(done0_encode),
            .F(t[0]),
            .B(ek_PKE_1)
        );
    
        encode #() enc1 (
            .start(start_encode),
                    .done(done1_encode),
                    .F(t[1]),
                    .B(ek_PKE_2)
        );
    
        encode #() enc2 (
            .start(start_encode),
                    .done(done2_encode),
                    .F(t[2]),
                    .B(ek_PKE_3)
        );
        
        //---------------------s-----------------
        encode #() enc4 (
                    .start(start_encode),
                    .done(done3_encode),
                    .F(s_ntt[0]),
                    .B(dk_PKE_1)
                );
            
                encode #() enc5 (
                    .start(start_encode),
                            .done(done4_encode),
                            .F(s_ntt[1]),
                            .B(dk_PKE_2)
                );
            
                encode #() enc6 (
                    .start(start_encode),
                            .done(done5_encode),
                            .F(s_ntt[2]),
                            .B(dk_PKE_3)
                );

genvar i;
generate
    for (i = 0; i < 384; i++) begin
       assign ek_PKE[i*8 +: 8]           = ek_PKE_1[i];
        assign ek_PKE[(i+384)*8 +: 8]     = ek_PKE_2[i];
        assign ek_PKE[(i+768)*8 +: 8]     = ek_PKE_3[i];
        assign dk_PKE[i*8 +: 8]           = dk_PKE_1[i];
                assign dk_PKE[(i+384)*8 +: 8]     = dk_PKE_2[i];
                assign dk_PKE[(i+768)*8 +: 8]     = dk_PKE_3[i];
    end
    assign ek_PKE[9471:9216] = rho;
endgenerate

logic ntt_started;
logic mul;
logic rho_done;
reg load_next;
logic delay_counter;
logic start_delay;

  always_ff @(posedge clk or posedge rst) begin
           if (rst) begin
//           done0_ntt <= 0;
//                   done1_ntt <= 0;
//                   done2_ntt <= 0;
//                   done3_ntt <= 0;
//                   done4_ntt <= 0;
//                   done5_ntt <= 0;
           ntt_started <=0;
               all_shake_done <= 0;
               start1<=0;
                load_next <= 0;
//               started_mul    <= 0;
               mul <= 0;
               rho_done<=0;
                       start_encode <= 0;
                       start_parse  <= 0;
                       start_cbd    <= 0;
                       start_prf    <= 0; 
//                       start_ntt <= 0;// Reset the flag when reset is active
           delay_counter <= 0;
        start_delay   <= 0;
        done<=0;
        
    end else if (!done) begin
    $display("d=%h",d);
        
//        rho_done <= 1;
//        done_check <= done8_shake;

        if (done_sha && !start_delay) begin
            start_delay <= 1;
            delay_counter <= 0;
        end

        if (start_delay && delay_counter < 5) begin
            delay_counter <= delay_counter + 1;
        end

        if (delay_counter == 5) begin
            start1 <= 1;  // Delay complete
            $display("Delayed start1: time=%0t, xof = %h", $time, xof);
            start_delay <= 0;  // Reset delay logic if needed
        end

                   start_encode <= 0;
                   start_parse  <= 0;
                   start_cbd    <= 0;
                   start_prf    <= 0;
                   
                   if (done_sha) begin
            start1 <= 1;
            $display("HAMNA",xof);
            
            end 

    $display("time=%0t done_sha=%b, load_next=%b, start1=%b, rho=%h", $time, done_sha, load_next, start1, rho);



          
           zetas[0] = 17; zetas[1] = 2761; zetas[2] = 583; zetas[3] = 2649; zetas[4] = 1637; zetas[5] = 723; zetas[6] = 2288; zetas[7] = 1100;
                   zetas[8] = 1409; zetas[9] = 2662; zetas[10] = 3281; zetas[11] = 233; zetas[12] = 756; zetas[13] = 2156; zetas[14] = 3015; zetas[15] = 3050;
                   zetas[16] = 1703; zetas[17] = 1651; zetas[18] = 2789; zetas[19] = 1789; zetas[20] = 1847; zetas[21] = 952; zetas[22] = 1461; zetas[23] = 2687;
                   zetas[24] = 939; zetas[25] = 2308; zetas[26] = 2437; zetas[27] = 2388; zetas[28] = 733; zetas[29] = 2337; zetas[30] = 268; zetas[31] = 641;
                   zetas[32] = 1584; zetas[33] = 2298; zetas[34] = 2037; zetas[35] = 3220; zetas[36] = 375; zetas[37] = 2549; zetas[38] = 2090; zetas[39] = 1645;
                   zetas[40] = 1063; zetas[41] = 319; zetas[42] = 2773; zetas[43] = 757; zetas[44] = 2099; zetas[45] = 561; zetas[46] = 2466; zetas[47] = 2594;
                   zetas[48] = 2804; zetas[49] = 1092; zetas[50] = 403; zetas[51] = 1026; zetas[52] = 1143; zetas[53] = 2150; zetas[54] = 2775; zetas[55] = 886;
                   zetas[56] = 1722; zetas[57] = 1212; zetas[58] = 1874; zetas[59] = 1029; zetas[60] = 2110; zetas[61] = 2935; zetas[62] = 885; zetas[63] = 2154;
                   zetas[64] = 289; zetas[65] = 331; zetas[66] = 3253; zetas[67] = 1756; zetas[68] = 1197; zetas[69] = 2304; zetas[70] = 2277; zetas[71] = 2055;
                   zetas[72] = 650; zetas[73] = 1977; zetas[74] = 2513; zetas[75] = 632; zetas[76] = 2865; zetas[77] = 33; zetas[78] = 1320; zetas[79] = 1915;
                   zetas[80] = 2319; zetas[81] = 1435; zetas[82] = 807; zetas[83] = 452; zetas[84] = 1438; zetas[85] = 2868; zetas[86] = 1534; zetas[87] = 2402;
                   zetas[88] = 2647; zetas[89] = 2617; zetas[90] = 1481; zetas[91] = 648; zetas[92] = 2474; zetas[93] = 3110; zetas[94] = 1227; zetas[95] = 910;
                   zetas[96] = 296; zetas[97] = 2447; zetas[98] = 1339; zetas[99] = 1476; zetas[100] = 3046; zetas[101] = 56; zetas[102] = 2240; zetas[103] = 1333;
                   zetas[104] = 1426; zetas[105] = 2094; zetas[106] = 535; zetas[107] = 2882; zetas[108] = 2393; zetas[109] = 2879; zetas[110] = 1974; zetas[111] = 821;
                   zetas[112] = 1062; zetas[113] = 1919; zetas[114] = 193; zetas[115] = 797; zetas[116] = 2786; zetas[117] = 3260; zetas[118] = 569; zetas[119] = 1746;
                   zetas[120] = 2642; zetas[121] = 630; zetas[122] = 1897; zetas[123] = 848; zetas[124] = 2580; zetas[125] = 3289; zetas[126] = 1729; zetas[127] = 3328;
//            zetas[17] = 2637;
          
          
          for (int i = 0; i < 768; i = i + 1) begin
                            
                                          parse_array1[i] = xof[(i+1)*8-1 -: 8];
                                           parse_array2[i] = xof2[(i+1)*8-1 -: 8];
                                            parse_array3[i] = xof3[(i+1)*8-1 -: 8];
                                             parse_array4[i] = xof4[(i+1)*8-1 -: 8];
                                              parse_array5[i] = xof5[(i+1)*8-1 -: 8];
                                               parse_array6[i] = xof6[(i+1)*8-1 -: 8];
                                                parse_array7[i] = xof7[(i+1)*8-1 -: 8];
                                                 parse_array8[i] = xof8[(i+1)*8-1 -: 8];
                                                  parse_array9[i] = xof9[(i+1)*8-1 -: 8];
                                             
           end
            if ( done8_shake) begin
                             start_parse <= 1;
                             start1 <= 0; // Set flag when all shake modules are done
                         end
                         
                           for (int i = 0; i < 128; i++) begin
                                                    prf_bytes_0[i] = prf_0[8*i +: 8];
                                                    prf_bytes_1[i] = prf_1[8*i +: 8];
                                                    prf_bytes_2[i] = prf_2[8*i +: 8];
                                                    prf_bytes_3[i] = prf_3[8*i +: 8];
                                                    prf_bytes_4[i] = prf_4[8*i +: 8];
                                                    prf_bytes_5[i] = prf_5[8*i +: 8];
                                                    $display("making prf in");
                                                end
            if (done8) begin
                                                      start_parse <= 0;
                                                      start_prf <= 1;
                                                      $display("checking prf");
                                                       // Set flag when all shake modules are done
                                                  end
//done_check <= start_prf;
             if (done14_shake && done0_cbd !== 1'b1) begin
                                                   all_shake_done <= 1;
                                                   start_prf <= 0; 
                                                   start_cbd <= 1;// Set flag when all shake modules are done
                                                   end 
//                                                   $display("CHECK",done5_cbd); 
//                                                   $display("CHECK0", done0_ntt);
//                                                   $display("CHECK1", done1_ntt);
//                                                   $display("CHECK2", done2_ntt);
//                                                   $display("CHECK3", done3_ntt);
//                                                   $display("CHECK4", done4_ntt);
//                                                   $display("CHECK5", done5_ntt);
                                                   
//            if (done5_cbd && !done0_ntt && !done1_ntt && !done2_ntt && !done3_ntt && !done4_ntt && !done5_ntt && !ntt_started) begin
                                                       
                                                                       
//                                                 ntt_started <= 1;
//                                                  start_ntt <= 1;// Set flag when all shake modules are done
//                                                  end 
                                                                                            
           
           
            
//           $display("CHECK",parse_array9);
//           $display("rho",rho);
//           $display("digest", digest[255:0]);
               // Check if all XOF modules have completed (all done signals are high)
              
               
                      
//                                      if (!mul && done0_ntt && done1_ntt && done2_ntt && done3_ntt &&
//                                                         done4_ntt && done5_ntt && !done0_mul && !done1_mul && !done2_mul && !done3_mul && !done4_mul && !done5_mul && !done6_mul && !done7_mul && !done8_mul) begin
////                                                         done14_shake <= 0;
////                                                            start_ntt <= 0;
//                                                         start_mul <= 1; 
//                                                         end
//                                                         else begin 
////                                                         start_mul <=0;
//                                                         end
                                                         // Set flag when all shake modules are done
                                                     if (done0_mul && done1_mul && done2_mul && done3_mul && done4_mul && done5_mul && done6_mul && done7_mul && done8_mul) begin
//                                                             start_mul <= 0;  // Reset the flag once all mul operations are done
                                                              t[0][0] <= (((mult_out_00[0] + mult_out_01[0] + mult_out_02[0])%3329) + e_ntt[0][0])%3329;
t[0][1] <= (((mult_out_00[1] + mult_out_01[1] + mult_out_02[1])%3329) + e_ntt[0][1])%3329;
t[0][2] <= (((mult_out_00[2] + mult_out_01[2] + mult_out_02[2])%3329) + e_ntt[0][2])%3329;
t[0][3] <= (((mult_out_00[3] + mult_out_01[3] + mult_out_02[3])%3329) + e_ntt[0][3])%3329;
t[0][4] <= (((mult_out_00[4] + mult_out_01[4] + mult_out_02[4])%3329) + e_ntt[0][4])%3329;
t[0][5] <= (((mult_out_00[5] + mult_out_01[5] + mult_out_02[5])%3329) + e_ntt[0][5])%3329;
t[0][6] <= (((mult_out_00[6] + mult_out_01[6] + mult_out_02[6])%3329) + e_ntt[0][6])%3329;
t[0][7] <= (((mult_out_00[7] + mult_out_01[7] + mult_out_02[7])%3329) + e_ntt[0][7])%3329;
t[0][8] <= (((mult_out_00[8] + mult_out_01[8] + mult_out_02[8])%3329) + e_ntt[0][8])%3329;
t[0][9] <= (((mult_out_00[9] + mult_out_01[9] + mult_out_02[9])%3329) + e_ntt[0][9])%3329;
t[0][10] <= (((mult_out_00[10] + mult_out_01[10] + mult_out_02[10])%3329) + e_ntt[0][10])%3329;
t[0][11] <= (((mult_out_00[11] + mult_out_01[11] + mult_out_02[11])%3329) + e_ntt[0][11])%3329;
t[0][12] <= (((mult_out_00[12] + mult_out_01[12] + mult_out_02[12])%3329) + e_ntt[0][12])%3329;
t[0][13] <= (((mult_out_00[13] + mult_out_01[13] + mult_out_02[13])%3329) + e_ntt[0][13])%3329;
t[0][14] <= (((mult_out_00[14] + mult_out_01[14] + mult_out_02[14])%3329) + e_ntt[0][14])%3329;
t[0][15] <= (((mult_out_00[15] + mult_out_01[15] + mult_out_02[15])%3329) + e_ntt[0][15])%3329;
t[0][16] <= (((mult_out_00[16] + mult_out_01[16] + mult_out_02[16])%3329) + e_ntt[0][16])%3329;
t[0][17] <= (((mult_out_00[17] + mult_out_01[17] + mult_out_02[17])%3329) + e_ntt[0][17])%3329;
t[0][18] <= (((mult_out_00[18] + mult_out_01[18] + mult_out_02[18])%3329) + e_ntt[0][18])%3329;
t[0][19] <= (((mult_out_00[19] + mult_out_01[19] + mult_out_02[19])%3329) + e_ntt[0][19])%3329;
t[0][20] <= (((mult_out_00[20] + mult_out_01[20] + mult_out_02[20])%3329) + e_ntt[0][20])%3329;
t[0][21] <= (((mult_out_00[21] + mult_out_01[21] + mult_out_02[21])%3329) + e_ntt[0][21])%3329;
t[0][22] <= (((mult_out_00[22] + mult_out_01[22] + mult_out_02[22])%3329) + e_ntt[0][22])%3329;
t[0][23] <= (((mult_out_00[23] + mult_out_01[23] + mult_out_02[23])%3329) + e_ntt[0][23])%3329;
t[0][24] <= (((mult_out_00[24] + mult_out_01[24] + mult_out_02[24])%3329) + e_ntt[0][24])%3329;
t[0][25] <= (((mult_out_00[25] + mult_out_01[25] + mult_out_02[25])%3329) + e_ntt[0][25])%3329;
t[0][26] <= (((mult_out_00[26] + mult_out_01[26] + mult_out_02[26])%3329) + e_ntt[0][26])%3329;
t[0][27] <= (((mult_out_00[27] + mult_out_01[27] + mult_out_02[27])%3329) + e_ntt[0][27])%3329;
t[0][28] <= (((mult_out_00[28] + mult_out_01[28] + mult_out_02[28])%3329) + e_ntt[0][28])%3329;
t[0][29] <= (((mult_out_00[29] + mult_out_01[29] + mult_out_02[29])%3329) + e_ntt[0][29])%3329;
t[0][30] <= (((mult_out_00[30] + mult_out_01[30] + mult_out_02[30])%3329) + e_ntt[0][30])%3329;
t[0][31] <= (((mult_out_00[31] + mult_out_01[31] + mult_out_02[31])%3329) + e_ntt[0][31])%3329;
t[0][32] <= (((mult_out_00[32] + mult_out_01[32] + mult_out_02[32])%3329) + e_ntt[0][32])%3329;
t[0][33] <= (((mult_out_00[33] + mult_out_01[33] + mult_out_02[33])%3329) + e_ntt[0][33])%3329;
t[0][34] <= (((mult_out_00[34] + mult_out_01[34] + mult_out_02[34])%3329) + e_ntt[0][34])%3329;
t[0][35] <= (((mult_out_00[35] + mult_out_01[35] + mult_out_02[35])%3329) + e_ntt[0][35])%3329;
t[0][36] <= (((mult_out_00[36] + mult_out_01[36] + mult_out_02[36])%3329) + e_ntt[0][36])%3329;
t[0][37] <= (((mult_out_00[37] + mult_out_01[37] + mult_out_02[37])%3329) + e_ntt[0][37])%3329;
t[0][38] <= (((mult_out_00[38] + mult_out_01[38] + mult_out_02[38])%3329) + e_ntt[0][38])%3329;
t[0][39] <= (((mult_out_00[39] + mult_out_01[39] + mult_out_02[39])%3329) + e_ntt[0][39])%3329;
t[0][40] <= (((mult_out_00[40] + mult_out_01[40] + mult_out_02[40])%3329) + e_ntt[0][40])%3329;
t[0][41] <= (((mult_out_00[41] + mult_out_01[41] + mult_out_02[41])%3329) + e_ntt[0][41])%3329;
t[0][42] <= (((mult_out_00[42] + mult_out_01[42] + mult_out_02[42])%3329) + e_ntt[0][42])%3329;
t[0][43] <= (((mult_out_00[43] + mult_out_01[43] + mult_out_02[43])%3329) + e_ntt[0][43])%3329;
t[0][44] <= (((mult_out_00[44] + mult_out_01[44] + mult_out_02[44])%3329) + e_ntt[0][44])%3329;
t[0][45] <= (((mult_out_00[45] + mult_out_01[45] + mult_out_02[45])%3329) + e_ntt[0][45])%3329;
t[0][46] <= (((mult_out_00[46] + mult_out_01[46] + mult_out_02[46])%3329) + e_ntt[0][46])%3329;
t[0][47] <= (((mult_out_00[47] + mult_out_01[47] + mult_out_02[47])%3329) + e_ntt[0][47])%3329;
t[0][48] <= (((mult_out_00[48] + mult_out_01[48] + mult_out_02[48])%3329) + e_ntt[0][48])%3329;
t[0][49] <= (((mult_out_00[49] + mult_out_01[49] + mult_out_02[49])%3329) + e_ntt[0][49])%3329;
t[0][50] <= (((mult_out_00[50] + mult_out_01[50] + mult_out_02[50])%3329) + e_ntt[0][50])%3329;
t[0][51] <= (((mult_out_00[51] + mult_out_01[51] + mult_out_02[51])%3329) + e_ntt[0][51])%3329;
t[0][52] <= (((mult_out_00[52] + mult_out_01[52] + mult_out_02[52])%3329) + e_ntt[0][52])%3329;
t[0][53] <= (((mult_out_00[53] + mult_out_01[53] + mult_out_02[53])%3329) + e_ntt[0][53])%3329;
t[0][54] <= (((mult_out_00[54] + mult_out_01[54] + mult_out_02[54])%3329) + e_ntt[0][54])%3329;
t[0][55] <= (((mult_out_00[55] + mult_out_01[55] + mult_out_02[55])%3329) + e_ntt[0][55])%3329;
t[0][56] <= (((mult_out_00[56] + mult_out_01[56] + mult_out_02[56])%3329) + e_ntt[0][56])%3329;
t[0][57] <= (((mult_out_00[57] + mult_out_01[57] + mult_out_02[57])%3329) + e_ntt[0][57])%3329;
t[0][58] <= (((mult_out_00[58] + mult_out_01[58] + mult_out_02[58])%3329) + e_ntt[0][58])%3329;
t[0][59] <= (((mult_out_00[59] + mult_out_01[59] + mult_out_02[59])%3329) + e_ntt[0][59])%3329;
t[0][60] <= (((mult_out_00[60] + mult_out_01[60] + mult_out_02[60])%3329) + e_ntt[0][60])%3329;
t[0][61] <= (((mult_out_00[61] + mult_out_01[61] + mult_out_02[61])%3329) + e_ntt[0][61])%3329;
t[0][62] <= (((mult_out_00[62] + mult_out_01[62] + mult_out_02[62])%3329) + e_ntt[0][62])%3329;
t[0][63] <= (((mult_out_00[63] + mult_out_01[63] + mult_out_02[63])%3329) + e_ntt[0][63])%3329;
t[0][64] <= (((mult_out_00[64] + mult_out_01[64] + mult_out_02[64])%3329) + e_ntt[0][64])%3329;
t[0][65] <= (((mult_out_00[65] + mult_out_01[65] + mult_out_02[65])%3329) + e_ntt[0][65])%3329;
t[0][66] <= (((mult_out_00[66] + mult_out_01[66] + mult_out_02[66])%3329) + e_ntt[0][66])%3329;
t[0][67] <= (((mult_out_00[67] + mult_out_01[67] + mult_out_02[67])%3329) + e_ntt[0][67])%3329;
t[0][68] <= (((mult_out_00[68] + mult_out_01[68] + mult_out_02[68])%3329) + e_ntt[0][68])%3329;
t[0][69] <= (((mult_out_00[69] + mult_out_01[69] + mult_out_02[69])%3329) + e_ntt[0][69])%3329;
t[0][70] <= (((mult_out_00[70] + mult_out_01[70] + mult_out_02[70])%3329) + e_ntt[0][70])%3329;
t[0][71] <= (((mult_out_00[71] + mult_out_01[71] + mult_out_02[71])%3329) + e_ntt[0][71])%3329;
t[0][72] <= (((mult_out_00[72] + mult_out_01[72] + mult_out_02[72])%3329) + e_ntt[0][72])%3329;
t[0][73] <= (((mult_out_00[73] + mult_out_01[73] + mult_out_02[73])%3329) + e_ntt[0][73])%3329;
t[0][74] <= (((mult_out_00[74] + mult_out_01[74] + mult_out_02[74])%3329) + e_ntt[0][74])%3329;
t[0][75] <= (((mult_out_00[75] + mult_out_01[75] + mult_out_02[75])%3329) + e_ntt[0][75])%3329;
t[0][76] <= (((mult_out_00[76] + mult_out_01[76] + mult_out_02[76])%3329) + e_ntt[0][76])%3329;
t[0][77] <= (((mult_out_00[77] + mult_out_01[77] + mult_out_02[77])%3329) + e_ntt[0][77])%3329;
t[0][78] <= (((mult_out_00[78] + mult_out_01[78] + mult_out_02[78])%3329) + e_ntt[0][78])%3329;
t[0][79] <= (((mult_out_00[79] + mult_out_01[79] + mult_out_02[79])%3329) + e_ntt[0][79])%3329;
t[0][80] <= (((mult_out_00[80] + mult_out_01[80] + mult_out_02[80])%3329) + e_ntt[0][80])%3329;
t[0][81] <= (((mult_out_00[81] + mult_out_01[81] + mult_out_02[81])%3329) + e_ntt[0][81])%3329;
t[0][82] <= (((mult_out_00[82] + mult_out_01[82] + mult_out_02[82])%3329) + e_ntt[0][82])%3329;
t[0][83] <= (((mult_out_00[83] + mult_out_01[83] + mult_out_02[83])%3329) + e_ntt[0][83])%3329;
t[0][84] <= (((mult_out_00[84] + mult_out_01[84] + mult_out_02[84])%3329) + e_ntt[0][84])%3329;
t[0][85] <= (((mult_out_00[85] + mult_out_01[85] + mult_out_02[85])%3329) + e_ntt[0][85])%3329;
t[0][86] <= (((mult_out_00[86] + mult_out_01[86] + mult_out_02[86])%3329) + e_ntt[0][86])%3329;
t[0][87] <= (((mult_out_00[87] + mult_out_01[87] + mult_out_02[87])%3329) + e_ntt[0][87])%3329;
t[0][88] <= (((mult_out_00[88] + mult_out_01[88] + mult_out_02[88])%3329) + e_ntt[0][88])%3329;
t[0][89] <= (((mult_out_00[89] + mult_out_01[89] + mult_out_02[89])%3329) + e_ntt[0][89])%3329;
t[0][90] <= (((mult_out_00[90] + mult_out_01[90] + mult_out_02[90])%3329) + e_ntt[0][90])%3329;
t[0][91] <= (((mult_out_00[91] + mult_out_01[91] + mult_out_02[91])%3329) + e_ntt[0][91])%3329;
t[0][92] <= (((mult_out_00[92] + mult_out_01[92] + mult_out_02[92])%3329) + e_ntt[0][92])%3329;
t[0][93] <= (((mult_out_00[93] + mult_out_01[93] + mult_out_02[93])%3329) + e_ntt[0][93])%3329;
t[0][94] <= (((mult_out_00[94] + mult_out_01[94] + mult_out_02[94])%3329) + e_ntt[0][94])%3329;
t[0][95] <= (((mult_out_00[95] + mult_out_01[95] + mult_out_02[95])%3329) + e_ntt[0][95])%3329;
t[0][96] <= (((mult_out_00[96] + mult_out_01[96] + mult_out_02[96])%3329) + e_ntt[0][96])%3329;
t[0][97] <= (((mult_out_00[97] + mult_out_01[97] + mult_out_02[97])%3329) + e_ntt[0][97])%3329;
t[0][98] <= (((mult_out_00[98] + mult_out_01[98] + mult_out_02[98])%3329) + e_ntt[0][98])%3329;
t[0][99] <= (((mult_out_00[99] + mult_out_01[99] + mult_out_02[99])%3329) + e_ntt[0][99])%3329;
t[0][100] <= (((mult_out_00[100] + mult_out_01[100] + mult_out_02[100])%3329) + e_ntt[0][100])%3329;
t[0][101] <= (((mult_out_00[101] + mult_out_01[101] + mult_out_02[101])%3329) + e_ntt[0][101])%3329;
t[0][102] <= (((mult_out_00[102] + mult_out_01[102] + mult_out_02[102])%3329) + e_ntt[0][102])%3329;
t[0][103] <= (((mult_out_00[103] + mult_out_01[103] + mult_out_02[103])%3329) + e_ntt[0][103])%3329;
t[0][104] <= (((mult_out_00[104] + mult_out_01[104] + mult_out_02[104])%3329) + e_ntt[0][104])%3329;
t[0][105] <= (((mult_out_00[105] + mult_out_01[105] + mult_out_02[105])%3329) + e_ntt[0][105])%3329;
t[0][106] <= (((mult_out_00[106] + mult_out_01[106] + mult_out_02[106])%3329) + e_ntt[0][106])%3329;
t[0][107] <= (((mult_out_00[107] + mult_out_01[107] + mult_out_02[107])%3329) + e_ntt[0][107])%3329;
t[0][108] <= (((mult_out_00[108] + mult_out_01[108] + mult_out_02[108])%3329) + e_ntt[0][108])%3329;
t[0][109] <= (((mult_out_00[109] + mult_out_01[109] + mult_out_02[109])%3329) + e_ntt[0][109])%3329;
t[0][110] <= (((mult_out_00[110] + mult_out_01[110] + mult_out_02[110])%3329) + e_ntt[0][110])%3329;
t[0][111] <= (((mult_out_00[111] + mult_out_01[111] + mult_out_02[111])%3329) + e_ntt[0][111])%3329;
t[0][112] <= (((mult_out_00[112] + mult_out_01[112] + mult_out_02[112])%3329) + e_ntt[0][112])%3329;
t[0][113] <= (((mult_out_00[113] + mult_out_01[113] + mult_out_02[113])%3329) + e_ntt[0][113])%3329;
t[0][114] <= (((mult_out_00[114] + mult_out_01[114] + mult_out_02[114])%3329) + e_ntt[0][114])%3329;
t[0][115] <= (((mult_out_00[115] + mult_out_01[115] + mult_out_02[115])%3329) + e_ntt[0][115])%3329;
t[0][116] <= (((mult_out_00[116] + mult_out_01[116] + mult_out_02[116])%3329) + e_ntt[0][116])%3329;
t[0][117] <= (((mult_out_00[117] + mult_out_01[117] + mult_out_02[117])%3329) + e_ntt[0][117])%3329;
t[0][118] <= (((mult_out_00[118] + mult_out_01[118] + mult_out_02[118])%3329) + e_ntt[0][118])%3329;
t[0][119] <= (((mult_out_00[119] + mult_out_01[119] + mult_out_02[119])%3329) + e_ntt[0][119])%3329;
t[0][120] <= (((mult_out_00[120] + mult_out_01[120] + mult_out_02[120])%3329) + e_ntt[0][120])%3329;
t[0][121] <= (((mult_out_00[121] + mult_out_01[121] + mult_out_02[121])%3329) + e_ntt[0][121])%3329;
t[0][122] <= (((mult_out_00[122] + mult_out_01[122] + mult_out_02[122])%3329) + e_ntt[0][122])%3329;
t[0][123] <= (((mult_out_00[123] + mult_out_01[123] + mult_out_02[123])%3329) + e_ntt[0][123])%3329;
t[0][124] <= (((mult_out_00[124] + mult_out_01[124] + mult_out_02[124])%3329) + e_ntt[0][124])%3329;
t[0][125] <= (((mult_out_00[125] + mult_out_01[125] + mult_out_02[125])%3329) + e_ntt[0][125])%3329;
t[0][126] <= (((mult_out_00[126] + mult_out_01[126] + mult_out_02[126])%3329) + e_ntt[0][126])%3329;
t[0][127] <= (((mult_out_00[127] + mult_out_01[127] + mult_out_02[127])%3329) + e_ntt[0][127])%3329;
t[0][128] <= (((mult_out_00[128] + mult_out_01[128] + mult_out_02[128])%3329) + e_ntt[0][128])%3329;
t[0][129] <= (((mult_out_00[129] + mult_out_01[129] + mult_out_02[129])%3329) + e_ntt[0][129])%3329;
t[0][130] <= (((mult_out_00[130] + mult_out_01[130] + mult_out_02[130])%3329) + e_ntt[0][130])%3329;
t[0][131] <= (((mult_out_00[131] + mult_out_01[131] + mult_out_02[131])%3329) + e_ntt[0][131])%3329;
t[0][132] <= (((mult_out_00[132] + mult_out_01[132] + mult_out_02[132])%3329) + e_ntt[0][132])%3329;
t[0][133] <= (((mult_out_00[133] + mult_out_01[133] + mult_out_02[133])%3329) + e_ntt[0][133])%3329;
t[0][134] <= (((mult_out_00[134] + mult_out_01[134] + mult_out_02[134])%3329) + e_ntt[0][134])%3329;
t[0][135] <= (((mult_out_00[135] + mult_out_01[135] + mult_out_02[135])%3329) + e_ntt[0][135])%3329;
t[0][136] <= (((mult_out_00[136] + mult_out_01[136] + mult_out_02[136])%3329) + e_ntt[0][136])%3329;
t[0][137] <= (((mult_out_00[137] + mult_out_01[137] + mult_out_02[137])%3329) + e_ntt[0][137])%3329;
t[0][138] <= (((mult_out_00[138] + mult_out_01[138] + mult_out_02[138])%3329) + e_ntt[0][138])%3329;
t[0][139] <= (((mult_out_00[139] + mult_out_01[139] + mult_out_02[139])%3329) + e_ntt[0][139])%3329;
t[0][140] <= (((mult_out_00[140] + mult_out_01[140] + mult_out_02[140])%3329) + e_ntt[0][140])%3329;
t[0][141] <= (((mult_out_00[141] + mult_out_01[141] + mult_out_02[141])%3329) + e_ntt[0][141])%3329;
t[0][142] <= (((mult_out_00[142] + mult_out_01[142] + mult_out_02[142])%3329) + e_ntt[0][142])%3329;
t[0][143] <= (((mult_out_00[143] + mult_out_01[143] + mult_out_02[143])%3329) + e_ntt[0][143])%3329;
t[0][144] <= (((mult_out_00[144] + mult_out_01[144] + mult_out_02[144])%3329) + e_ntt[0][144])%3329;
t[0][145] <= (((mult_out_00[145] + mult_out_01[145] + mult_out_02[145])%3329) + e_ntt[0][145])%3329;
t[0][146] <= (((mult_out_00[146] + mult_out_01[146] + mult_out_02[146])%3329) + e_ntt[0][146])%3329;
t[0][147] <= (((mult_out_00[147] + mult_out_01[147] + mult_out_02[147])%3329) + e_ntt[0][147])%3329;
t[0][148] <= (((mult_out_00[148] + mult_out_01[148] + mult_out_02[148])%3329) + e_ntt[0][148])%3329;
t[0][149] <= (((mult_out_00[149] + mult_out_01[149] + mult_out_02[149])%3329) + e_ntt[0][149])%3329;
t[0][150] <= (((mult_out_00[150] + mult_out_01[150] + mult_out_02[150])%3329) + e_ntt[0][150])%3329;
t[0][151] <= (((mult_out_00[151] + mult_out_01[151] + mult_out_02[151])%3329) + e_ntt[0][151])%3329;
t[0][152] <= (((mult_out_00[152] + mult_out_01[152] + mult_out_02[152])%3329) + e_ntt[0][152])%3329;
t[0][153] <= (((mult_out_00[153] + mult_out_01[153] + mult_out_02[153])%3329) + e_ntt[0][153])%3329;
t[0][154] <= (((mult_out_00[154] + mult_out_01[154] + mult_out_02[154])%3329) + e_ntt[0][154])%3329;
t[0][155] <= (((mult_out_00[155] + mult_out_01[155] + mult_out_02[155])%3329) + e_ntt[0][155])%3329;
t[0][156] <= (((mult_out_00[156] + mult_out_01[156] + mult_out_02[156])%3329) + e_ntt[0][156])%3329;
t[0][157] <= (((mult_out_00[157] + mult_out_01[157] + mult_out_02[157])%3329) + e_ntt[0][157])%3329;
t[0][158] <= (((mult_out_00[158] + mult_out_01[158] + mult_out_02[158])%3329) + e_ntt[0][158])%3329;
t[0][159] <= (((mult_out_00[159] + mult_out_01[159] + mult_out_02[159])%3329) + e_ntt[0][159])%3329;
t[0][160] <= (((mult_out_00[160] + mult_out_01[160] + mult_out_02[160])%3329) + e_ntt[0][160])%3329;
t[0][161] <= (((mult_out_00[161] + mult_out_01[161] + mult_out_02[161])%3329) + e_ntt[0][161])%3329;
t[0][162] <= (((mult_out_00[162] + mult_out_01[162] + mult_out_02[162])%3329) + e_ntt[0][162])%3329;
t[0][163] <= (((mult_out_00[163] + mult_out_01[163] + mult_out_02[163])%3329) + e_ntt[0][163])%3329;
t[0][164] <= (((mult_out_00[164] + mult_out_01[164] + mult_out_02[164])%3329) + e_ntt[0][164])%3329;
t[0][165] <= (((mult_out_00[165] + mult_out_01[165] + mult_out_02[165])%3329) + e_ntt[0][165])%3329;
t[0][166] <= (((mult_out_00[166] + mult_out_01[166] + mult_out_02[166])%3329) + e_ntt[0][166])%3329;
t[0][167] <= (((mult_out_00[167] + mult_out_01[167] + mult_out_02[167])%3329) + e_ntt[0][167])%3329;
t[0][168] <= (((mult_out_00[168] + mult_out_01[168] + mult_out_02[168])%3329) + e_ntt[0][168])%3329;
t[0][169] <= (((mult_out_00[169] + mult_out_01[169] + mult_out_02[169])%3329) + e_ntt[0][169])%3329;
t[0][170] <= (((mult_out_00[170] + mult_out_01[170] + mult_out_02[170])%3329) + e_ntt[0][170])%3329;
t[0][171] <= (((mult_out_00[171] + mult_out_01[171] + mult_out_02[171])%3329) + e_ntt[0][171])%3329;
t[0][172] <= (((mult_out_00[172] + mult_out_01[172] + mult_out_02[172])%3329) + e_ntt[0][172])%3329;
t[0][173] <= (((mult_out_00[173] + mult_out_01[173] + mult_out_02[173])%3329) + e_ntt[0][173])%3329;
t[0][174] <= (((mult_out_00[174] + mult_out_01[174] + mult_out_02[174])%3329) + e_ntt[0][174])%3329;
t[0][175] <= (((mult_out_00[175] + mult_out_01[175] + mult_out_02[175])%3329) + e_ntt[0][175])%3329;
t[0][176] <= (((mult_out_00[176] + mult_out_01[176] + mult_out_02[176])%3329) + e_ntt[0][176])%3329;
t[0][177] <= (((mult_out_00[177] + mult_out_01[177] + mult_out_02[177])%3329) + e_ntt[0][177])%3329;
t[0][178] <= (((mult_out_00[178] + mult_out_01[178] + mult_out_02[178])%3329) + e_ntt[0][178])%3329;
t[0][179] <= (((mult_out_00[179] + mult_out_01[179] + mult_out_02[179])%3329) + e_ntt[0][179])%3329;
t[0][180] <= (((mult_out_00[180] + mult_out_01[180] + mult_out_02[180])%3329) + e_ntt[0][180])%3329;
t[0][181] <= (((mult_out_00[181] + mult_out_01[181] + mult_out_02[181])%3329) + e_ntt[0][181])%3329;
t[0][182] <= (((mult_out_00[182] + mult_out_01[182] + mult_out_02[182])%3329) + e_ntt[0][182])%3329;
t[0][183] <= (((mult_out_00[183] + mult_out_01[183] + mult_out_02[183])%3329) + e_ntt[0][183])%3329;
t[0][184] <= (((mult_out_00[184] + mult_out_01[184] + mult_out_02[184])%3329) + e_ntt[0][184])%3329;
t[0][185] <= (((mult_out_00[185] + mult_out_01[185] + mult_out_02[185])%3329) + e_ntt[0][185])%3329;
t[0][186] <= (((mult_out_00[186] + mult_out_01[186] + mult_out_02[186])%3329) + e_ntt[0][186])%3329;
t[0][187] <= (((mult_out_00[187] + mult_out_01[187] + mult_out_02[187])%3329) + e_ntt[0][187])%3329;
t[0][188] <= (((mult_out_00[188] + mult_out_01[188] + mult_out_02[188])%3329) + e_ntt[0][188])%3329;
t[0][189] <= (((mult_out_00[189] + mult_out_01[189] + mult_out_02[189])%3329) + e_ntt[0][189])%3329;
t[0][190] <= (((mult_out_00[190] + mult_out_01[190] + mult_out_02[190])%3329) + e_ntt[0][190])%3329;
t[0][191] <= (((mult_out_00[191] + mult_out_01[191] + mult_out_02[191])%3329) + e_ntt[0][191])%3329;
t[0][192] <= (((mult_out_00[192] + mult_out_01[192] + mult_out_02[192])%3329) + e_ntt[0][192])%3329;
t[0][193] <= (((mult_out_00[193] + mult_out_01[193] + mult_out_02[193])%3329) + e_ntt[0][193])%3329;
t[0][194] <= (((mult_out_00[194] + mult_out_01[194] + mult_out_02[194])%3329) + e_ntt[0][194])%3329;
t[0][195] <= (((mult_out_00[195] + mult_out_01[195] + mult_out_02[195])%3329) + e_ntt[0][195])%3329;
t[0][196] <= (((mult_out_00[196] + mult_out_01[196] + mult_out_02[196])%3329) + e_ntt[0][196])%3329;
t[0][197] <= (((mult_out_00[197] + mult_out_01[197] + mult_out_02[197])%3329) + e_ntt[0][197])%3329;
t[0][198] <= (((mult_out_00[198] + mult_out_01[198] + mult_out_02[198])%3329) + e_ntt[0][198])%3329;
t[0][199] <= (((mult_out_00[199] + mult_out_01[199] + mult_out_02[199])%3329) + e_ntt[0][199])%3329;
t[0][200] <= (((mult_out_00[200] + mult_out_01[200] + mult_out_02[200])%3329) + e_ntt[0][200])%3329;
t[0][201] <= (((mult_out_00[201] + mult_out_01[201] + mult_out_02[201])%3329) + e_ntt[0][201])%3329;
t[0][202] <= (((mult_out_00[202] + mult_out_01[202] + mult_out_02[202])%3329) + e_ntt[0][202])%3329;
t[0][203] <= (((mult_out_00[203] + mult_out_01[203] + mult_out_02[203])%3329) + e_ntt[0][203])%3329;
t[0][204] <= (((mult_out_00[204] + mult_out_01[204] + mult_out_02[204])%3329) + e_ntt[0][204])%3329;
t[0][205] <= (((mult_out_00[205] + mult_out_01[205] + mult_out_02[205])%3329) + e_ntt[0][205])%3329;
t[0][206] <= (((mult_out_00[206] + mult_out_01[206] + mult_out_02[206])%3329) + e_ntt[0][206])%3329;
t[0][207] <= (((mult_out_00[207] + mult_out_01[207] + mult_out_02[207])%3329) + e_ntt[0][207])%3329;
t[0][208] <= (((mult_out_00[208] + mult_out_01[208] + mult_out_02[208])%3329) + e_ntt[0][208])%3329;
t[0][209] <= (((mult_out_00[209] + mult_out_01[209] + mult_out_02[209])%3329) + e_ntt[0][209])%3329;
t[0][210] <= (((mult_out_00[210] + mult_out_01[210] + mult_out_02[210])%3329) + e_ntt[0][210])%3329;
t[0][211] <= (((mult_out_00[211] + mult_out_01[211] + mult_out_02[211])%3329) + e_ntt[0][211])%3329;
t[0][212] <= (((mult_out_00[212] + mult_out_01[212] + mult_out_02[212])%3329) + e_ntt[0][212])%3329;
t[0][213] <= (((mult_out_00[213] + mult_out_01[213] + mult_out_02[213])%3329) + e_ntt[0][213])%3329;
t[0][214] <= (((mult_out_00[214] + mult_out_01[214] + mult_out_02[214])%3329) + e_ntt[0][214])%3329;
t[0][215] <= (((mult_out_00[215] + mult_out_01[215] + mult_out_02[215])%3329) + e_ntt[0][215])%3329;
t[0][216] <= (((mult_out_00[216] + mult_out_01[216] + mult_out_02[216])%3329) + e_ntt[0][216])%3329;
t[0][217] <= (((mult_out_00[217] + mult_out_01[217] + mult_out_02[217])%3329) + e_ntt[0][217])%3329;
t[0][218] <= (((mult_out_00[218] + mult_out_01[218] + mult_out_02[218])%3329) + e_ntt[0][218])%3329;
t[0][219] <= (((mult_out_00[219] + mult_out_01[219] + mult_out_02[219])%3329) + e_ntt[0][219])%3329;
t[0][220] <= (((mult_out_00[220] + mult_out_01[220] + mult_out_02[220])%3329) + e_ntt[0][220])%3329;
t[0][221] <= (((mult_out_00[221] + mult_out_01[221] + mult_out_02[221])%3329) + e_ntt[0][221])%3329;
t[0][222] <= (((mult_out_00[222] + mult_out_01[222] + mult_out_02[222])%3329) + e_ntt[0][222])%3329;
t[0][223] <= (((mult_out_00[223] + mult_out_01[223] + mult_out_02[223])%3329) + e_ntt[0][223])%3329;
t[0][224] <= (((mult_out_00[224] + mult_out_01[224] + mult_out_02[224])%3329) + e_ntt[0][224])%3329;
t[0][225] <= (((mult_out_00[225] + mult_out_01[225] + mult_out_02[225])%3329) + e_ntt[0][225])%3329;
t[0][226] <= (((mult_out_00[226] + mult_out_01[226] + mult_out_02[226])%3329) + e_ntt[0][226])%3329;
t[0][227] <= (((mult_out_00[227] + mult_out_01[227] + mult_out_02[227])%3329) + e_ntt[0][227])%3329;
t[0][228] <= (((mult_out_00[228] + mult_out_01[228] + mult_out_02[228])%3329) + e_ntt[0][228])%3329;
t[0][229] <= (((mult_out_00[229] + mult_out_01[229] + mult_out_02[229])%3329) + e_ntt[0][229])%3329;
t[0][230] <= (((mult_out_00[230] + mult_out_01[230] + mult_out_02[230])%3329) + e_ntt[0][230])%3329;
t[0][231] <= (((mult_out_00[231] + mult_out_01[231] + mult_out_02[231])%3329) + e_ntt[0][231])%3329;
t[0][232] <= (((mult_out_00[232] + mult_out_01[232] + mult_out_02[232])%3329) + e_ntt[0][232])%3329;
t[0][233] <= (((mult_out_00[233] + mult_out_01[233] + mult_out_02[233])%3329) + e_ntt[0][233])%3329;
t[0][234] <= (((mult_out_00[234] + mult_out_01[234] + mult_out_02[234])%3329) + e_ntt[0][234])%3329;
t[0][235] <= (((mult_out_00[235] + mult_out_01[235] + mult_out_02[235])%3329) + e_ntt[0][235])%3329;
t[0][236] <= (((mult_out_00[236] + mult_out_01[236] + mult_out_02[236])%3329) + e_ntt[0][236])%3329;
t[0][237] <= (((mult_out_00[237] + mult_out_01[237] + mult_out_02[237])%3329) + e_ntt[0][237])%3329;
t[0][238] <= (((mult_out_00[238] + mult_out_01[238] + mult_out_02[238])%3329) + e_ntt[0][238])%3329;
t[0][239] <= (((mult_out_00[239] + mult_out_01[239] + mult_out_02[239])%3329) + e_ntt[0][239])%3329;
t[0][240] <= (((mult_out_00[240] + mult_out_01[240] + mult_out_02[240])%3329) + e_ntt[0][240])%3329;
t[0][241] <= (((mult_out_00[241] + mult_out_01[241] + mult_out_02[241])%3329) + e_ntt[0][241])%3329;
t[0][242] <= (((mult_out_00[242] + mult_out_01[242] + mult_out_02[242])%3329) + e_ntt[0][242])%3329;
t[0][243] <= (((mult_out_00[243] + mult_out_01[243] + mult_out_02[243])%3329) + e_ntt[0][243])%3329;
t[0][244] <= (((mult_out_00[244] + mult_out_01[244] + mult_out_02[244])%3329) + e_ntt[0][244])%3329;
t[0][245] <= (((mult_out_00[245] + mult_out_01[245] + mult_out_02[245])%3329) + e_ntt[0][245])%3329;
t[0][246] <= (((mult_out_00[246] + mult_out_01[246] + mult_out_02[246])%3329) + e_ntt[0][246])%3329;
t[0][247] <= (((mult_out_00[247] + mult_out_01[247] + mult_out_02[247])%3329) + e_ntt[0][247])%3329;
t[0][248] <= (((mult_out_00[248] + mult_out_01[248] + mult_out_02[248])%3329) + e_ntt[0][248])%3329;
t[0][249] <= (((mult_out_00[249] + mult_out_01[249] + mult_out_02[249])%3329) + e_ntt[0][249])%3329;
t[0][250] <= (((mult_out_00[250] + mult_out_01[250] + mult_out_02[250])%3329) + e_ntt[0][250])%3329;
t[0][251] <= (((mult_out_00[251] + mult_out_01[251] + mult_out_02[251])%3329) + e_ntt[0][251])%3329;
t[0][252] <= (((mult_out_00[252] + mult_out_01[252] + mult_out_02[252])%3329) + e_ntt[0][252])%3329;
t[0][253] <= (((mult_out_00[253] + mult_out_01[253] + mult_out_02[253])%3329) + e_ntt[0][253])%3329;
t[0][254] <= (((mult_out_00[254] + mult_out_01[254] + mult_out_02[254])%3329) + e_ntt[0][254])%3329;
t[0][255] <= (((mult_out_00[255] + mult_out_01[255] + mult_out_02[255])%3329) + e_ntt[0][255])%3329;
                                                             
                                                             t[1][0] <= (((mult_out_10[0] + mult_out_11[0] + mult_out_12[0])%3329) + e_ntt[1][0])%3329;
t[1][1] <= (((mult_out_10[1] + mult_out_11[1] + mult_out_12[1])%3329) + e_ntt[1][1])%3329;
t[1][2] <= (((mult_out_10[2] + mult_out_11[2] + mult_out_12[2])%3329) + e_ntt[1][2])%3329;
t[1][3] <= (((mult_out_10[3] + mult_out_11[3] + mult_out_12[3])%3329) + e_ntt[1][3])%3329;
t[1][4] <= (((mult_out_10[4] + mult_out_11[4] + mult_out_12[4])%3329) + e_ntt[1][4])%3329;
t[1][5] <= (((mult_out_10[5] + mult_out_11[5] + mult_out_12[5])%3329) + e_ntt[1][5])%3329;
t[1][6] <= (((mult_out_10[6] + mult_out_11[6] + mult_out_12[6])%3329) + e_ntt[1][6])%3329;
t[1][7] <= (((mult_out_10[7] + mult_out_11[7] + mult_out_12[7])%3329) + e_ntt[1][7])%3329;
t[1][8] <= (((mult_out_10[8] + mult_out_11[8] + mult_out_12[8])%3329) + e_ntt[1][8])%3329;
t[1][9] <= (((mult_out_10[9] + mult_out_11[9] + mult_out_12[9])%3329) + e_ntt[1][9])%3329;
t[1][10] <= (((mult_out_10[10] + mult_out_11[10] + mult_out_12[10])%3329) + e_ntt[1][10])%3329;
t[1][11] <= (((mult_out_10[11] + mult_out_11[11] + mult_out_12[11])%3329) + e_ntt[1][11])%3329;
t[1][12] <= (((mult_out_10[12] + mult_out_11[12] + mult_out_12[12])%3329) + e_ntt[1][12])%3329;
t[1][13] <= (((mult_out_10[13] + mult_out_11[13] + mult_out_12[13])%3329) + e_ntt[1][13])%3329;
t[1][14] <= (((mult_out_10[14] + mult_out_11[14] + mult_out_12[14])%3329) + e_ntt[1][14])%3329;
t[1][15] <= (((mult_out_10[15] + mult_out_11[15] + mult_out_12[15])%3329) + e_ntt[1][15])%3329;
t[1][16] <= (((mult_out_10[16] + mult_out_11[16] + mult_out_12[16])%3329) + e_ntt[1][16])%3329;
t[1][17] <= (((mult_out_10[17] + mult_out_11[17] + mult_out_12[17])%3329) + e_ntt[1][17])%3329;
t[1][18] <= (((mult_out_10[18] + mult_out_11[18] + mult_out_12[18])%3329) + e_ntt[1][18])%3329;
t[1][19] <= (((mult_out_10[19] + mult_out_11[19] + mult_out_12[19])%3329) + e_ntt[1][19])%3329;
t[1][20] <= (((mult_out_10[20] + mult_out_11[20] + mult_out_12[20])%3329) + e_ntt[1][20])%3329;
t[1][21] <= (((mult_out_10[21] + mult_out_11[21] + mult_out_12[21])%3329) + e_ntt[1][21])%3329;
t[1][22] <= (((mult_out_10[22] + mult_out_11[22] + mult_out_12[22])%3329) + e_ntt[1][22])%3329;
t[1][23] <= (((mult_out_10[23] + mult_out_11[23] + mult_out_12[23])%3329) + e_ntt[1][23])%3329;
t[1][24] <= (((mult_out_10[24] + mult_out_11[24] + mult_out_12[24])%3329) + e_ntt[1][24])%3329;
t[1][25] <= (((mult_out_10[25] + mult_out_11[25] + mult_out_12[25])%3329) + e_ntt[1][25])%3329;
t[1][26] <= (((mult_out_10[26] + mult_out_11[26] + mult_out_12[26])%3329) + e_ntt[1][26])%3329;
t[1][27] <= (((mult_out_10[27] + mult_out_11[27] + mult_out_12[27])%3329) + e_ntt[1][27])%3329;
t[1][28] <= (((mult_out_10[28] + mult_out_11[28] + mult_out_12[28])%3329) + e_ntt[1][28])%3329;
t[1][29] <= (((mult_out_10[29] + mult_out_11[29] + mult_out_12[29])%3329) + e_ntt[1][29])%3329;
t[1][30] <= (((mult_out_10[30] + mult_out_11[30] + mult_out_12[30])%3329) + e_ntt[1][30])%3329;
t[1][31] <= (((mult_out_10[31] + mult_out_11[31] + mult_out_12[31])%3329) + e_ntt[1][31])%3329;
t[1][32] <= (((mult_out_10[32] + mult_out_11[32] + mult_out_12[32])%3329) + e_ntt[1][32])%3329;
t[1][33] <= (((mult_out_10[33] + mult_out_11[33] + mult_out_12[33])%3329) + e_ntt[1][33])%3329;
t[1][34] <= (((mult_out_10[34] + mult_out_11[34] + mult_out_12[34])%3329) + e_ntt[1][34])%3329;
t[1][35] <= (((mult_out_10[35] + mult_out_11[35] + mult_out_12[35])%3329) + e_ntt[1][35])%3329;
t[1][36] <= (((mult_out_10[36] + mult_out_11[36] + mult_out_12[36])%3329) + e_ntt[1][36])%3329;
t[1][37] <= (((mult_out_10[37] + mult_out_11[37] + mult_out_12[37])%3329) + e_ntt[1][37])%3329;
t[1][38] <= (((mult_out_10[38] + mult_out_11[38] + mult_out_12[38])%3329) + e_ntt[1][38])%3329;
t[1][39] <= (((mult_out_10[39] + mult_out_11[39] + mult_out_12[39])%3329) + e_ntt[1][39])%3329;
t[1][40] <= (((mult_out_10[40] + mult_out_11[40] + mult_out_12[40])%3329) + e_ntt[1][40])%3329;
t[1][41] <= (((mult_out_10[41] + mult_out_11[41] + mult_out_12[41])%3329) + e_ntt[1][41])%3329;
t[1][42] <= (((mult_out_10[42] + mult_out_11[42] + mult_out_12[42])%3329) + e_ntt[1][42])%3329;
t[1][43] <= (((mult_out_10[43] + mult_out_11[43] + mult_out_12[43])%3329) + e_ntt[1][43])%3329;
t[1][44] <= (((mult_out_10[44] + mult_out_11[44] + mult_out_12[44])%3329) + e_ntt[1][44])%3329;
t[1][45] <= (((mult_out_10[45] + mult_out_11[45] + mult_out_12[45])%3329) + e_ntt[1][45])%3329;
t[1][46] <= (((mult_out_10[46] + mult_out_11[46] + mult_out_12[46])%3329) + e_ntt[1][46])%3329;
t[1][47] <= (((mult_out_10[47] + mult_out_11[47] + mult_out_12[47])%3329) + e_ntt[1][47])%3329;
t[1][48] <= (((mult_out_10[48] + mult_out_11[48] + mult_out_12[48])%3329) + e_ntt[1][48])%3329;
t[1][49] <= (((mult_out_10[49] + mult_out_11[49] + mult_out_12[49])%3329) + e_ntt[1][49])%3329;
t[1][50] <= (((mult_out_10[50] + mult_out_11[50] + mult_out_12[50])%3329) + e_ntt[1][50])%3329;
t[1][51] <= (((mult_out_10[51] + mult_out_11[51] + mult_out_12[51])%3329) + e_ntt[1][51])%3329;
t[1][52] <= (((mult_out_10[52] + mult_out_11[52] + mult_out_12[52])%3329) + e_ntt[1][52])%3329;
t[1][53] <= (((mult_out_10[53] + mult_out_11[53] + mult_out_12[53])%3329) + e_ntt[1][53])%3329;
t[1][54] <= (((mult_out_10[54] + mult_out_11[54] + mult_out_12[54])%3329) + e_ntt[1][54])%3329;
t[1][55] <= (((mult_out_10[55] + mult_out_11[55] + mult_out_12[55])%3329) + e_ntt[1][55])%3329;
t[1][56] <= (((mult_out_10[56] + mult_out_11[56] + mult_out_12[56])%3329) + e_ntt[1][56])%3329;
t[1][57] <= (((mult_out_10[57] + mult_out_11[57] + mult_out_12[57])%3329) + e_ntt[1][57])%3329;
t[1][58] <= (((mult_out_10[58] + mult_out_11[58] + mult_out_12[58])%3329) + e_ntt[1][58])%3329;
t[1][59] <= (((mult_out_10[59] + mult_out_11[59] + mult_out_12[59])%3329) + e_ntt[1][59])%3329;
t[1][60] <= (((mult_out_10[60] + mult_out_11[60] + mult_out_12[60])%3329) + e_ntt[1][60])%3329;
t[1][61] <= (((mult_out_10[61] + mult_out_11[61] + mult_out_12[61])%3329) + e_ntt[1][61])%3329;
t[1][62] <= (((mult_out_10[62] + mult_out_11[62] + mult_out_12[62])%3329) + e_ntt[1][62])%3329;
t[1][63] <= (((mult_out_10[63] + mult_out_11[63] + mult_out_12[63])%3329) + e_ntt[1][63])%3329;
t[1][64] <= (((mult_out_10[64] + mult_out_11[64] + mult_out_12[64])%3329) + e_ntt[1][64])%3329;
t[1][65] <= (((mult_out_10[65] + mult_out_11[65] + mult_out_12[65])%3329) + e_ntt[1][65])%3329;
t[1][66] <= (((mult_out_10[66] + mult_out_11[66] + mult_out_12[66])%3329) + e_ntt[1][66])%3329;
t[1][67] <= (((mult_out_10[67] + mult_out_11[67] + mult_out_12[67])%3329) + e_ntt[1][67])%3329;
t[1][68] <= (((mult_out_10[68] + mult_out_11[68] + mult_out_12[68])%3329) + e_ntt[1][68])%3329;
t[1][69] <= (((mult_out_10[69] + mult_out_11[69] + mult_out_12[69])%3329) + e_ntt[1][69])%3329;
t[1][70] <= (((mult_out_10[70] + mult_out_11[70] + mult_out_12[70])%3329) + e_ntt[1][70])%3329;
t[1][71] <= (((mult_out_10[71] + mult_out_11[71] + mult_out_12[71])%3329) + e_ntt[1][71])%3329;
t[1][72] <= (((mult_out_10[72] + mult_out_11[72] + mult_out_12[72])%3329) + e_ntt[1][72])%3329;
t[1][73] <= (((mult_out_10[73] + mult_out_11[73] + mult_out_12[73])%3329) + e_ntt[1][73])%3329;
t[1][74] <= (((mult_out_10[74] + mult_out_11[74] + mult_out_12[74])%3329) + e_ntt[1][74])%3329;
t[1][75] <= (((mult_out_10[75] + mult_out_11[75] + mult_out_12[75])%3329) + e_ntt[1][75])%3329;
t[1][76] <= (((mult_out_10[76] + mult_out_11[76] + mult_out_12[76])%3329) + e_ntt[1][76])%3329;
t[1][77] <= (((mult_out_10[77] + mult_out_11[77] + mult_out_12[77])%3329) + e_ntt[1][77])%3329;
t[1][78] <= (((mult_out_10[78] + mult_out_11[78] + mult_out_12[78])%3329) + e_ntt[1][78])%3329;
t[1][79] <= (((mult_out_10[79] + mult_out_11[79] + mult_out_12[79])%3329) + e_ntt[1][79])%3329;
t[1][80] <= (((mult_out_10[80] + mult_out_11[80] + mult_out_12[80])%3329) + e_ntt[1][80])%3329;
t[1][81] <= (((mult_out_10[81] + mult_out_11[81] + mult_out_12[81])%3329) + e_ntt[1][81])%3329;
t[1][82] <= (((mult_out_10[82] + mult_out_11[82] + mult_out_12[82])%3329) + e_ntt[1][82])%3329;
t[1][83] <= (((mult_out_10[83] + mult_out_11[83] + mult_out_12[83])%3329) + e_ntt[1][83])%3329;
t[1][84] <= (((mult_out_10[84] + mult_out_11[84] + mult_out_12[84])%3329) + e_ntt[1][84])%3329;
t[1][85] <= (((mult_out_10[85] + mult_out_11[85] + mult_out_12[85])%3329) + e_ntt[1][85])%3329;
t[1][86] <= (((mult_out_10[86] + mult_out_11[86] + mult_out_12[86])%3329) + e_ntt[1][86])%3329;
t[1][87] <= (((mult_out_10[87] + mult_out_11[87] + mult_out_12[87])%3329) + e_ntt[1][87])%3329;
t[1][88] <= (((mult_out_10[88] + mult_out_11[88] + mult_out_12[88])%3329) + e_ntt[1][88])%3329;
t[1][89] <= (((mult_out_10[89] + mult_out_11[89] + mult_out_12[89])%3329) + e_ntt[1][89])%3329;
t[1][90] <= (((mult_out_10[90] + mult_out_11[90] + mult_out_12[90])%3329) + e_ntt[1][90])%3329;
t[1][91] <= (((mult_out_10[91] + mult_out_11[91] + mult_out_12[91])%3329) + e_ntt[1][91])%3329;
t[1][92] <= (((mult_out_10[92] + mult_out_11[92] + mult_out_12[92])%3329) + e_ntt[1][92])%3329;
t[1][93] <= (((mult_out_10[93] + mult_out_11[93] + mult_out_12[93])%3329) + e_ntt[1][93])%3329;
t[1][94] <= (((mult_out_10[94] + mult_out_11[94] + mult_out_12[94])%3329) + e_ntt[1][94])%3329;
t[1][95] <= (((mult_out_10[95] + mult_out_11[95] + mult_out_12[95])%3329) + e_ntt[1][95])%3329;
t[1][96] <= (((mult_out_10[96] + mult_out_11[96] + mult_out_12[96])%3329) + e_ntt[1][96])%3329;
t[1][97] <= (((mult_out_10[97] + mult_out_11[97] + mult_out_12[97])%3329) + e_ntt[1][97])%3329;
t[1][98] <= (((mult_out_10[98] + mult_out_11[98] + mult_out_12[98])%3329) + e_ntt[1][98])%3329;
t[1][99] <= (((mult_out_10[99] + mult_out_11[99] + mult_out_12[99])%3329) + e_ntt[1][99])%3329;
t[1][100] <= (((mult_out_10[100] + mult_out_11[100] + mult_out_12[100])%3329) + e_ntt[1][100])%3329;
t[1][101] <= (((mult_out_10[101] + mult_out_11[101] + mult_out_12[101])%3329) + e_ntt[1][101])%3329;
t[1][102] <= (((mult_out_10[102] + mult_out_11[102] + mult_out_12[102])%3329) + e_ntt[1][102])%3329;
t[1][103] <= (((mult_out_10[103] + mult_out_11[103] + mult_out_12[103])%3329) + e_ntt[1][103])%3329;
t[1][104] <= (((mult_out_10[104] + mult_out_11[104] + mult_out_12[104])%3329) + e_ntt[1][104])%3329;
t[1][105] <= (((mult_out_10[105] + mult_out_11[105] + mult_out_12[105])%3329) + e_ntt[1][105])%3329;
t[1][106] <= (((mult_out_10[106] + mult_out_11[106] + mult_out_12[106])%3329) + e_ntt[1][106])%3329;
t[1][107] <= (((mult_out_10[107] + mult_out_11[107] + mult_out_12[107])%3329) + e_ntt[1][107])%3329;
t[1][108] <= (((mult_out_10[108] + mult_out_11[108] + mult_out_12[108])%3329) + e_ntt[1][108])%3329;
t[1][109] <= (((mult_out_10[109] + mult_out_11[109] + mult_out_12[109])%3329) + e_ntt[1][109])%3329;
t[1][110] <= (((mult_out_10[110] + mult_out_11[110] + mult_out_12[110])%3329) + e_ntt[1][110])%3329;
t[1][111] <= (((mult_out_10[111] + mult_out_11[111] + mult_out_12[111])%3329) + e_ntt[1][111])%3329;
t[1][112] <= (((mult_out_10[112] + mult_out_11[112] + mult_out_12[112])%3329) + e_ntt[1][112])%3329;
t[1][113] <= (((mult_out_10[113] + mult_out_11[113] + mult_out_12[113])%3329) + e_ntt[1][113])%3329;
t[1][114] <= (((mult_out_10[114] + mult_out_11[114] + mult_out_12[114])%3329) + e_ntt[1][114])%3329;
t[1][115] <= (((mult_out_10[115] + mult_out_11[115] + mult_out_12[115])%3329) + e_ntt[1][115])%3329;
t[1][116] <= (((mult_out_10[116] + mult_out_11[116] + mult_out_12[116])%3329) + e_ntt[1][116])%3329;
t[1][117] <= (((mult_out_10[117] + mult_out_11[117] + mult_out_12[117])%3329) + e_ntt[1][117])%3329;
t[1][118] <= (((mult_out_10[118] + mult_out_11[118] + mult_out_12[118])%3329) + e_ntt[1][118])%3329;
t[1][119] <= (((mult_out_10[119] + mult_out_11[119] + mult_out_12[119])%3329) + e_ntt[1][119])%3329;
t[1][120] <= (((mult_out_10[120] + mult_out_11[120] + mult_out_12[120])%3329) + e_ntt[1][120])%3329;
t[1][121] <= (((mult_out_10[121] + mult_out_11[121] + mult_out_12[121])%3329) + e_ntt[1][121])%3329;
t[1][122] <= (((mult_out_10[122] + mult_out_11[122] + mult_out_12[122])%3329) + e_ntt[1][122])%3329;
t[1][123] <= (((mult_out_10[123] + mult_out_11[123] + mult_out_12[123])%3329) + e_ntt[1][123])%3329;
t[1][124] <= (((mult_out_10[124] + mult_out_11[124] + mult_out_12[124])%3329) + e_ntt[1][124])%3329;
t[1][125] <= (((mult_out_10[125] + mult_out_11[125] + mult_out_12[125])%3329) + e_ntt[1][125])%3329;
t[1][126] <= (((mult_out_10[126] + mult_out_11[126] + mult_out_12[126])%3329) + e_ntt[1][126])%3329;
t[1][127] <= (((mult_out_10[127] + mult_out_11[127] + mult_out_12[127])%3329) + e_ntt[1][127])%3329;
t[1][128] <= (((mult_out_10[128] + mult_out_11[128] + mult_out_12[128])%3329) + e_ntt[1][128])%3329;
t[1][129] <= (((mult_out_10[129] + mult_out_11[129] + mult_out_12[129])%3329) + e_ntt[1][129])%3329;
t[1][130] <= (((mult_out_10[130] + mult_out_11[130] + mult_out_12[130])%3329) + e_ntt[1][130])%3329;
t[1][131] <= (((mult_out_10[131] + mult_out_11[131] + mult_out_12[131])%3329) + e_ntt[1][131])%3329;
t[1][132] <= (((mult_out_10[132] + mult_out_11[132] + mult_out_12[132])%3329) + e_ntt[1][132])%3329;
t[1][133] <= (((mult_out_10[133] + mult_out_11[133] + mult_out_12[133])%3329) + e_ntt[1][133])%3329;
t[1][134] <= (((mult_out_10[134] + mult_out_11[134] + mult_out_12[134])%3329) + e_ntt[1][134])%3329;
t[1][135] <= (((mult_out_10[135] + mult_out_11[135] + mult_out_12[135])%3329) + e_ntt[1][135])%3329;
t[1][136] <= (((mult_out_10[136] + mult_out_11[136] + mult_out_12[136])%3329) + e_ntt[1][136])%3329;
t[1][137] <= (((mult_out_10[137] + mult_out_11[137] + mult_out_12[137])%3329) + e_ntt[1][137])%3329;
t[1][138] <= (((mult_out_10[138] + mult_out_11[138] + mult_out_12[138])%3329) + e_ntt[1][138])%3329;
t[1][139] <= (((mult_out_10[139] + mult_out_11[139] + mult_out_12[139])%3329) + e_ntt[1][139])%3329;
t[1][140] <= (((mult_out_10[140] + mult_out_11[140] + mult_out_12[140])%3329) + e_ntt[1][140])%3329;
t[1][141] <= (((mult_out_10[141] + mult_out_11[141] + mult_out_12[141])%3329) + e_ntt[1][141])%3329;
t[1][142] <= (((mult_out_10[142] + mult_out_11[142] + mult_out_12[142])%3329) + e_ntt[1][142])%3329;
t[1][143] <= (((mult_out_10[143] + mult_out_11[143] + mult_out_12[143])%3329) + e_ntt[1][143])%3329;
t[1][144] <= (((mult_out_10[144] + mult_out_11[144] + mult_out_12[144])%3329) + e_ntt[1][144])%3329;
t[1][145] <= (((mult_out_10[145] + mult_out_11[145] + mult_out_12[145])%3329) + e_ntt[1][145])%3329;
t[1][146] <= (((mult_out_10[146] + mult_out_11[146] + mult_out_12[146])%3329) + e_ntt[1][146])%3329;
t[1][147] <= (((mult_out_10[147] + mult_out_11[147] + mult_out_12[147])%3329) + e_ntt[1][147])%3329;
t[1][148] <= (((mult_out_10[148] + mult_out_11[148] + mult_out_12[148])%3329) + e_ntt[1][148])%3329;
t[1][149] <= (((mult_out_10[149] + mult_out_11[149] + mult_out_12[149])%3329) + e_ntt[1][149])%3329;
t[1][150] <= (((mult_out_10[150] + mult_out_11[150] + mult_out_12[150])%3329) + e_ntt[1][150])%3329;
t[1][151] <= (((mult_out_10[151] + mult_out_11[151] + mult_out_12[151])%3329) + e_ntt[1][151])%3329;
t[1][152] <= (((mult_out_10[152] + mult_out_11[152] + mult_out_12[152])%3329) + e_ntt[1][152])%3329;
t[1][153] <= (((mult_out_10[153] + mult_out_11[153] + mult_out_12[153])%3329) + e_ntt[1][153])%3329;
t[1][154] <= (((mult_out_10[154] + mult_out_11[154] + mult_out_12[154])%3329) + e_ntt[1][154])%3329;
t[1][155] <= (((mult_out_10[155] + mult_out_11[155] + mult_out_12[155])%3329) + e_ntt[1][155])%3329;
t[1][156] <= (((mult_out_10[156] + mult_out_11[156] + mult_out_12[156])%3329) + e_ntt[1][156])%3329;
t[1][157] <= (((mult_out_10[157] + mult_out_11[157] + mult_out_12[157])%3329) + e_ntt[1][157])%3329;
t[1][158] <= (((mult_out_10[158] + mult_out_11[158] + mult_out_12[158])%3329) + e_ntt[1][158])%3329;
t[1][159] <= (((mult_out_10[159] + mult_out_11[159] + mult_out_12[159])%3329) + e_ntt[1][159])%3329;
t[1][160] <= (((mult_out_10[160] + mult_out_11[160] + mult_out_12[160])%3329) + e_ntt[1][160])%3329;
t[1][161] <= (((mult_out_10[161] + mult_out_11[161] + mult_out_12[161])%3329) + e_ntt[1][161])%3329;
t[1][162] <= (((mult_out_10[162] + mult_out_11[162] + mult_out_12[162])%3329) + e_ntt[1][162])%3329;
t[1][163] <= (((mult_out_10[163] + mult_out_11[163] + mult_out_12[163])%3329) + e_ntt[1][163])%3329;
t[1][164] <= (((mult_out_10[164] + mult_out_11[164] + mult_out_12[164])%3329) + e_ntt[1][164])%3329;
t[1][165] <= (((mult_out_10[165] + mult_out_11[165] + mult_out_12[165])%3329) + e_ntt[1][165])%3329;
t[1][166] <= (((mult_out_10[166] + mult_out_11[166] + mult_out_12[166])%3329) + e_ntt[1][166])%3329;
t[1][167] <= (((mult_out_10[167] + mult_out_11[167] + mult_out_12[167])%3329) + e_ntt[1][167])%3329;
t[1][168] <= (((mult_out_10[168] + mult_out_11[168] + mult_out_12[168])%3329) + e_ntt[1][168])%3329;
t[1][169] <= (((mult_out_10[169] + mult_out_11[169] + mult_out_12[169])%3329) + e_ntt[1][169])%3329;
t[1][170] <= (((mult_out_10[170] + mult_out_11[170] + mult_out_12[170])%3329) + e_ntt[1][170])%3329;
t[1][171] <= (((mult_out_10[171] + mult_out_11[171] + mult_out_12[171])%3329) + e_ntt[1][171])%3329;
t[1][172] <= (((mult_out_10[172] + mult_out_11[172] + mult_out_12[172])%3329) + e_ntt[1][172])%3329;
t[1][173] <= (((mult_out_10[173] + mult_out_11[173] + mult_out_12[173])%3329) + e_ntt[1][173])%3329;
t[1][174] <= (((mult_out_10[174] + mult_out_11[174] + mult_out_12[174])%3329) + e_ntt[1][174])%3329;
t[1][175] <= (((mult_out_10[175] + mult_out_11[175] + mult_out_12[175])%3329) + e_ntt[1][175])%3329;
t[1][176] <= (((mult_out_10[176] + mult_out_11[176] + mult_out_12[176])%3329) + e_ntt[1][176])%3329;
t[1][177] <= (((mult_out_10[177] + mult_out_11[177] + mult_out_12[177])%3329) + e_ntt[1][177])%3329;
t[1][178] <= (((mult_out_10[178] + mult_out_11[178] + mult_out_12[178])%3329) + e_ntt[1][178])%3329;
t[1][179] <= (((mult_out_10[179] + mult_out_11[179] + mult_out_12[179])%3329) + e_ntt[1][179])%3329;
t[1][180] <= (((mult_out_10[180] + mult_out_11[180] + mult_out_12[180])%3329) + e_ntt[1][180])%3329;
t[1][181] <= (((mult_out_10[181] + mult_out_11[181] + mult_out_12[181])%3329) + e_ntt[1][181])%3329;
t[1][182] <= (((mult_out_10[182] + mult_out_11[182] + mult_out_12[182])%3329) + e_ntt[1][182])%3329;
t[1][183] <= (((mult_out_10[183] + mult_out_11[183] + mult_out_12[183])%3329) + e_ntt[1][183])%3329;
t[1][184] <= (((mult_out_10[184] + mult_out_11[184] + mult_out_12[184])%3329) + e_ntt[1][184])%3329;
t[1][185] <= (((mult_out_10[185] + mult_out_11[185] + mult_out_12[185])%3329) + e_ntt[1][185])%3329;
t[1][186] <= (((mult_out_10[186] + mult_out_11[186] + mult_out_12[186])%3329) + e_ntt[1][186])%3329;
t[1][187] <= (((mult_out_10[187] + mult_out_11[187] + mult_out_12[187])%3329) + e_ntt[1][187])%3329;
t[1][188] <= (((mult_out_10[188] + mult_out_11[188] + mult_out_12[188])%3329) + e_ntt[1][188])%3329;
t[1][189] <= (((mult_out_10[189] + mult_out_11[189] + mult_out_12[189])%3329) + e_ntt[1][189])%3329;
t[1][190] <= (((mult_out_10[190] + mult_out_11[190] + mult_out_12[190])%3329) + e_ntt[1][190])%3329;
t[1][191] <= (((mult_out_10[191] + mult_out_11[191] + mult_out_12[191])%3329) + e_ntt[1][191])%3329;
t[1][192] <= (((mult_out_10[192] + mult_out_11[192] + mult_out_12[192])%3329) + e_ntt[1][192])%3329;
t[1][193] <= (((mult_out_10[193] + mult_out_11[193] + mult_out_12[193])%3329) + e_ntt[1][193])%3329;
t[1][194] <= (((mult_out_10[194] + mult_out_11[194] + mult_out_12[194])%3329) + e_ntt[1][194])%3329;
t[1][195] <= (((mult_out_10[195] + mult_out_11[195] + mult_out_12[195])%3329) + e_ntt[1][195])%3329;
t[1][196] <= (((mult_out_10[196] + mult_out_11[196] + mult_out_12[196])%3329) + e_ntt[1][196])%3329;
t[1][197] <= (((mult_out_10[197] + mult_out_11[197] + mult_out_12[197])%3329) + e_ntt[1][197])%3329;
t[1][198] <= (((mult_out_10[198] + mult_out_11[198] + mult_out_12[198])%3329) + e_ntt[1][198])%3329;
t[1][199] <= (((mult_out_10[199] + mult_out_11[199] + mult_out_12[199])%3329) + e_ntt[1][199])%3329;
t[1][200] <= (((mult_out_10[200] + mult_out_11[200] + mult_out_12[200])%3329) + e_ntt[1][200])%3329;
t[1][201] <= (((mult_out_10[201] + mult_out_11[201] + mult_out_12[201])%3329) + e_ntt[1][201])%3329;
t[1][202] <= (((mult_out_10[202] + mult_out_11[202] + mult_out_12[202])%3329) + e_ntt[1][202])%3329;
t[1][203] <= (((mult_out_10[203] + mult_out_11[203] + mult_out_12[203])%3329) + e_ntt[1][203])%3329;
t[1][204] <= (((mult_out_10[204] + mult_out_11[204] + mult_out_12[204])%3329) + e_ntt[1][204])%3329;
t[1][205] <= (((mult_out_10[205] + mult_out_11[205] + mult_out_12[205])%3329) + e_ntt[1][205])%3329;
t[1][206] <= (((mult_out_10[206] + mult_out_11[206] + mult_out_12[206])%3329) + e_ntt[1][206])%3329;
t[1][207] <= (((mult_out_10[207] + mult_out_11[207] + mult_out_12[207])%3329) + e_ntt[1][207])%3329;
t[1][208] <= (((mult_out_10[208] + mult_out_11[208] + mult_out_12[208])%3329) + e_ntt[1][208])%3329;
t[1][209] <= (((mult_out_10[209] + mult_out_11[209] + mult_out_12[209])%3329) + e_ntt[1][209])%3329;
t[1][210] <= (((mult_out_10[210] + mult_out_11[210] + mult_out_12[210])%3329) + e_ntt[1][210])%3329;
t[1][211] <= (((mult_out_10[211] + mult_out_11[211] + mult_out_12[211])%3329) + e_ntt[1][211])%3329;
t[1][212] <= (((mult_out_10[212] + mult_out_11[212] + mult_out_12[212])%3329) + e_ntt[1][212])%3329;
t[1][213] <= (((mult_out_10[213] + mult_out_11[213] + mult_out_12[213])%3329) + e_ntt[1][213])%3329;
t[1][214] <= (((mult_out_10[214] + mult_out_11[214] + mult_out_12[214])%3329) + e_ntt[1][214])%3329;
t[1][215] <= (((mult_out_10[215] + mult_out_11[215] + mult_out_12[215])%3329) + e_ntt[1][215])%3329;
t[1][216] <= (((mult_out_10[216] + mult_out_11[216] + mult_out_12[216])%3329) + e_ntt[1][216])%3329;
t[1][217] <= (((mult_out_10[217] + mult_out_11[217] + mult_out_12[217])%3329) + e_ntt[1][217])%3329;
t[1][218] <= (((mult_out_10[218] + mult_out_11[218] + mult_out_12[218])%3329) + e_ntt[1][218])%3329;
t[1][219] <= (((mult_out_10[219] + mult_out_11[219] + mult_out_12[219])%3329) + e_ntt[1][219])%3329;
t[1][220] <= (((mult_out_10[220] + mult_out_11[220] + mult_out_12[220])%3329) + e_ntt[1][220])%3329;
t[1][221] <= (((mult_out_10[221] + mult_out_11[221] + mult_out_12[221])%3329) + e_ntt[1][221])%3329;
t[1][222] <= (((mult_out_10[222] + mult_out_11[222] + mult_out_12[222])%3329) + e_ntt[1][222])%3329;
t[1][223] <= (((mult_out_10[223] + mult_out_11[223] + mult_out_12[223])%3329) + e_ntt[1][223])%3329;
t[1][224] <= (((mult_out_10[224] + mult_out_11[224] + mult_out_12[224])%3329) + e_ntt[1][224])%3329;
t[1][225] <= (((mult_out_10[225] + mult_out_11[225] + mult_out_12[225])%3329) + e_ntt[1][225])%3329;
t[1][226] <= (((mult_out_10[226] + mult_out_11[226] + mult_out_12[226])%3329) + e_ntt[1][226])%3329;
t[1][227] <= (((mult_out_10[227] + mult_out_11[227] + mult_out_12[227])%3329) + e_ntt[1][227])%3329;
t[1][228] <= (((mult_out_10[228] + mult_out_11[228] + mult_out_12[228])%3329) + e_ntt[1][228])%3329;
t[1][229] <= (((mult_out_10[229] + mult_out_11[229] + mult_out_12[229])%3329) + e_ntt[1][229])%3329;
t[1][230] <= (((mult_out_10[230] + mult_out_11[230] + mult_out_12[230])%3329) + e_ntt[1][230])%3329;
t[1][231] <= (((mult_out_10[231] + mult_out_11[231] + mult_out_12[231])%3329) + e_ntt[1][231])%3329;
t[1][232] <= (((mult_out_10[232] + mult_out_11[232] + mult_out_12[232])%3329) + e_ntt[1][232])%3329;
t[1][233] <= (((mult_out_10[233] + mult_out_11[233] + mult_out_12[233])%3329) + e_ntt[1][233])%3329;
t[1][234] <= (((mult_out_10[234] + mult_out_11[234] + mult_out_12[234])%3329) + e_ntt[1][234])%3329;
t[1][235] <= (((mult_out_10[235] + mult_out_11[235] + mult_out_12[235])%3329) + e_ntt[1][235])%3329;
t[1][236] <= (((mult_out_10[236] + mult_out_11[236] + mult_out_12[236])%3329) + e_ntt[1][236])%3329;
t[1][237] <= (((mult_out_10[237] + mult_out_11[237] + mult_out_12[237])%3329) + e_ntt[1][237])%3329;
t[1][238] <= (((mult_out_10[238] + mult_out_11[238] + mult_out_12[238])%3329) + e_ntt[1][238])%3329;
t[1][239] <= (((mult_out_10[239] + mult_out_11[239] + mult_out_12[239])%3329) + e_ntt[1][239])%3329;
t[1][240] <= (((mult_out_10[240] + mult_out_11[240] + mult_out_12[240])%3329) + e_ntt[1][240])%3329;
t[1][241] <= (((mult_out_10[241] + mult_out_11[241] + mult_out_12[241])%3329) + e_ntt[1][241])%3329;
t[1][242] <= (((mult_out_10[242] + mult_out_11[242] + mult_out_12[242])%3329) + e_ntt[1][242])%3329;
t[1][243] <= (((mult_out_10[243] + mult_out_11[243] + mult_out_12[243])%3329) + e_ntt[1][243])%3329;
t[1][244] <= (((mult_out_10[244] + mult_out_11[244] + mult_out_12[244])%3329) + e_ntt[1][244])%3329;
t[1][245] <= (((mult_out_10[245] + mult_out_11[245] + mult_out_12[245])%3329) + e_ntt[1][245])%3329;
t[1][246] <= (((mult_out_10[246] + mult_out_11[246] + mult_out_12[246])%3329) + e_ntt[1][246])%3329;
t[1][247] <= (((mult_out_10[247] + mult_out_11[247] + mult_out_12[247])%3329) + e_ntt[1][247])%3329;
t[1][248] <= (((mult_out_10[248] + mult_out_11[248] + mult_out_12[248])%3329) + e_ntt[1][248])%3329;
t[1][249] <= (((mult_out_10[249] + mult_out_11[249] + mult_out_12[249])%3329) + e_ntt[1][249])%3329;
t[1][250] <= (((mult_out_10[250] + mult_out_11[250] + mult_out_12[250])%3329) + e_ntt[1][250])%3329;
t[1][251] <= (((mult_out_10[251] + mult_out_11[251] + mult_out_12[251])%3329) + e_ntt[1][251])%3329;
t[1][252] <= (((mult_out_10[252] + mult_out_11[252] + mult_out_12[252])%3329) + e_ntt[1][252])%3329;
t[1][253] <= (((mult_out_10[253] + mult_out_11[253] + mult_out_12[253])%3329) + e_ntt[1][253])%3329;
t[1][254] <= (((mult_out_10[254] + mult_out_11[254] + mult_out_12[254])%3329) + e_ntt[1][254])%3329;
t[1][255] <= (((mult_out_10[255] + mult_out_11[255] + mult_out_12[255])%3329) + e_ntt[1][255])%3329;
                                                         
                                                         t[2][0] <= (((mult_out_20[0] + mult_out_21[0] + mult_out_22[0])%3329) + e_ntt[2][0])%3329;
t[2][1] <= (((mult_out_20[1] + mult_out_21[1] + mult_out_22[1])%3329) + e_ntt[2][1])%3329;
t[2][2] <= (((mult_out_20[2] + mult_out_21[2] + mult_out_22[2])%3329) + e_ntt[2][2])%3329;
t[2][3] <= (((mult_out_20[3] + mult_out_21[3] + mult_out_22[3])%3329) + e_ntt[2][3])%3329;
t[2][4] <= (((mult_out_20[4] + mult_out_21[4] + mult_out_22[4])%3329) + e_ntt[2][4])%3329;
t[2][5] <= (((mult_out_20[5] + mult_out_21[5] + mult_out_22[5])%3329) + e_ntt[2][5])%3329;
t[2][6] <= (((mult_out_20[6] + mult_out_21[6] + mult_out_22[6])%3329) + e_ntt[2][6])%3329;
t[2][7] <= (((mult_out_20[7] + mult_out_21[7] + mult_out_22[7])%3329) + e_ntt[2][7])%3329;
t[2][8] <= (((mult_out_20[8] + mult_out_21[8] + mult_out_22[8])%3329) + e_ntt[2][8])%3329;
t[2][9] <= (((mult_out_20[9] + mult_out_21[9] + mult_out_22[9])%3329) + e_ntt[2][9])%3329;
t[2][10] <= (((mult_out_20[10] + mult_out_21[10] + mult_out_22[10])%3329) + e_ntt[2][10])%3329;
t[2][11] <= (((mult_out_20[11] + mult_out_21[11] + mult_out_22[11])%3329) + e_ntt[2][11])%3329;
t[2][12] <= (((mult_out_20[12] + mult_out_21[12] + mult_out_22[12])%3329) + e_ntt[2][12])%3329;
t[2][13] <= (((mult_out_20[13] + mult_out_21[13] + mult_out_22[13])%3329) + e_ntt[2][13])%3329;
t[2][14] <= (((mult_out_20[14] + mult_out_21[14] + mult_out_22[14])%3329) + e_ntt[2][14])%3329;
t[2][15] <= (((mult_out_20[15] + mult_out_21[15] + mult_out_22[15])%3329) + e_ntt[2][15])%3329;
t[2][16] <= (((mult_out_20[16] + mult_out_21[16] + mult_out_22[16])%3329) + e_ntt[2][16])%3329;
t[2][17] <= (((mult_out_20[17] + mult_out_21[17] + mult_out_22[17])%3329) + e_ntt[2][17])%3329;
t[2][18] <= (((mult_out_20[18] + mult_out_21[18] + mult_out_22[18])%3329) + e_ntt[2][18])%3329;
t[2][19] <= (((mult_out_20[19] + mult_out_21[19] + mult_out_22[19])%3329) + e_ntt[2][19])%3329;
t[2][20] <= (((mult_out_20[20] + mult_out_21[20] + mult_out_22[20])%3329) + e_ntt[2][20])%3329;
t[2][21] <= (((mult_out_20[21] + mult_out_21[21] + mult_out_22[21])%3329) + e_ntt[2][21])%3329;
t[2][22] <= (((mult_out_20[22] + mult_out_21[22] + mult_out_22[22])%3329) + e_ntt[2][22])%3329;
t[2][23] <= (((mult_out_20[23] + mult_out_21[23] + mult_out_22[23])%3329) + e_ntt[2][23])%3329;
t[2][24] <= (((mult_out_20[24] + mult_out_21[24] + mult_out_22[24])%3329) + e_ntt[2][24])%3329;
t[2][25] <= (((mult_out_20[25] + mult_out_21[25] + mult_out_22[25])%3329) + e_ntt[2][25])%3329;
t[2][26] <= (((mult_out_20[26] + mult_out_21[26] + mult_out_22[26])%3329) + e_ntt[2][26])%3329;
t[2][27] <= (((mult_out_20[27] + mult_out_21[27] + mult_out_22[27])%3329) + e_ntt[2][27])%3329;
t[2][28] <= (((mult_out_20[28] + mult_out_21[28] + mult_out_22[28])%3329) + e_ntt[2][28])%3329;
t[2][29] <= (((mult_out_20[29] + mult_out_21[29] + mult_out_22[29])%3329) + e_ntt[2][29])%3329;
t[2][30] <= (((mult_out_20[30] + mult_out_21[30] + mult_out_22[30])%3329) + e_ntt[2][30])%3329;
t[2][31] <= (((mult_out_20[31] + mult_out_21[31] + mult_out_22[31])%3329) + e_ntt[2][31])%3329;
t[2][32] <= (((mult_out_20[32] + mult_out_21[32] + mult_out_22[32])%3329) + e_ntt[2][32])%3329;
t[2][33] <= (((mult_out_20[33] + mult_out_21[33] + mult_out_22[33])%3329) + e_ntt[2][33])%3329;
t[2][34] <= (((mult_out_20[34] + mult_out_21[34] + mult_out_22[34])%3329) + e_ntt[2][34])%3329;
t[2][35] <= (((mult_out_20[35] + mult_out_21[35] + mult_out_22[35])%3329) + e_ntt[2][35])%3329;
t[2][36] <= (((mult_out_20[36] + mult_out_21[36] + mult_out_22[36])%3329) + e_ntt[2][36])%3329;
t[2][37] <= (((mult_out_20[37] + mult_out_21[37] + mult_out_22[37])%3329) + e_ntt[2][37])%3329;
t[2][38] <= (((mult_out_20[38] + mult_out_21[38] + mult_out_22[38])%3329) + e_ntt[2][38])%3329;
t[2][39] <= (((mult_out_20[39] + mult_out_21[39] + mult_out_22[39])%3329) + e_ntt[2][39])%3329;
t[2][40] <= (((mult_out_20[40] + mult_out_21[40] + mult_out_22[40])%3329) + e_ntt[2][40])%3329;
t[2][41] <= (((mult_out_20[41] + mult_out_21[41] + mult_out_22[41])%3329) + e_ntt[2][41])%3329;
t[2][42] <= (((mult_out_20[42] + mult_out_21[42] + mult_out_22[42])%3329) + e_ntt[2][42])%3329;
t[2][43] <= (((mult_out_20[43] + mult_out_21[43] + mult_out_22[43])%3329) + e_ntt[2][43])%3329;
t[2][44] <= (((mult_out_20[44] + mult_out_21[44] + mult_out_22[44])%3329) + e_ntt[2][44])%3329;
t[2][45] <= (((mult_out_20[45] + mult_out_21[45] + mult_out_22[45])%3329) + e_ntt[2][45])%3329;
t[2][46] <= (((mult_out_20[46] + mult_out_21[46] + mult_out_22[46])%3329) + e_ntt[2][46])%3329;
t[2][47] <= (((mult_out_20[47] + mult_out_21[47] + mult_out_22[47])%3329) + e_ntt[2][47])%3329;
t[2][48] <= (((mult_out_20[48] + mult_out_21[48] + mult_out_22[48])%3329) + e_ntt[2][48])%3329;
t[2][49] <= (((mult_out_20[49] + mult_out_21[49] + mult_out_22[49])%3329) + e_ntt[2][49])%3329;
t[2][50] <= (((mult_out_20[50] + mult_out_21[50] + mult_out_22[50])%3329) + e_ntt[2][50])%3329;
t[2][51] <= (((mult_out_20[51] + mult_out_21[51] + mult_out_22[51])%3329) + e_ntt[2][51])%3329;
t[2][52] <= (((mult_out_20[52] + mult_out_21[52] + mult_out_22[52])%3329) + e_ntt[2][52])%3329;
t[2][53] <= (((mult_out_20[53] + mult_out_21[53] + mult_out_22[53])%3329) + e_ntt[2][53])%3329;
t[2][54] <= (((mult_out_20[54] + mult_out_21[54] + mult_out_22[54])%3329) + e_ntt[2][54])%3329;
t[2][55] <= (((mult_out_20[55] + mult_out_21[55] + mult_out_22[55])%3329) + e_ntt[2][55])%3329;
t[2][56] <= (((mult_out_20[56] + mult_out_21[56] + mult_out_22[56])%3329) + e_ntt[2][56])%3329;
t[2][57] <= (((mult_out_20[57] + mult_out_21[57] + mult_out_22[57])%3329) + e_ntt[2][57])%3329;
t[2][58] <= (((mult_out_20[58] + mult_out_21[58] + mult_out_22[58])%3329) + e_ntt[2][58])%3329;
t[2][59] <= (((mult_out_20[59] + mult_out_21[59] + mult_out_22[59])%3329) + e_ntt[2][59])%3329;
t[2][60] <= (((mult_out_20[60] + mult_out_21[60] + mult_out_22[60])%3329) + e_ntt[2][60])%3329;
t[2][61] <= (((mult_out_20[61] + mult_out_21[61] + mult_out_22[61])%3329) + e_ntt[2][61])%3329;
t[2][62] <= (((mult_out_20[62] + mult_out_21[62] + mult_out_22[62])%3329) + e_ntt[2][62])%3329;
t[2][63] <= (((mult_out_20[63] + mult_out_21[63] + mult_out_22[63])%3329) + e_ntt[2][63])%3329;
t[2][64] <= (((mult_out_20[64] + mult_out_21[64] + mult_out_22[64])%3329) + e_ntt[2][64])%3329;
t[2][65] <= (((mult_out_20[65] + mult_out_21[65] + mult_out_22[65])%3329) + e_ntt[2][65])%3329;
t[2][66] <= (((mult_out_20[66] + mult_out_21[66] + mult_out_22[66])%3329) + e_ntt[2][66])%3329;
t[2][67] <= (((mult_out_20[67] + mult_out_21[67] + mult_out_22[67])%3329) + e_ntt[2][67])%3329;
t[2][68] <= (((mult_out_20[68] + mult_out_21[68] + mult_out_22[68])%3329) + e_ntt[2][68])%3329;
t[2][69] <= (((mult_out_20[69] + mult_out_21[69] + mult_out_22[69])%3329) + e_ntt[2][69])%3329;
t[2][70] <= (((mult_out_20[70] + mult_out_21[70] + mult_out_22[70])%3329) + e_ntt[2][70])%3329;
t[2][71] <= (((mult_out_20[71] + mult_out_21[71] + mult_out_22[71])%3329) + e_ntt[2][71])%3329;
t[2][72] <= (((mult_out_20[72] + mult_out_21[72] + mult_out_22[72])%3329) + e_ntt[2][72])%3329;
t[2][73] <= (((mult_out_20[73] + mult_out_21[73] + mult_out_22[73])%3329) + e_ntt[2][73])%3329;
t[2][74] <= (((mult_out_20[74] + mult_out_21[74] + mult_out_22[74])%3329) + e_ntt[2][74])%3329;
t[2][75] <= (((mult_out_20[75] + mult_out_21[75] + mult_out_22[75])%3329) + e_ntt[2][75])%3329;
t[2][76] <= (((mult_out_20[76] + mult_out_21[76] + mult_out_22[76])%3329) + e_ntt[2][76])%3329;
t[2][77] <= (((mult_out_20[77] + mult_out_21[77] + mult_out_22[77])%3329) + e_ntt[2][77])%3329;
t[2][78] <= (((mult_out_20[78] + mult_out_21[78] + mult_out_22[78])%3329) + e_ntt[2][78])%3329;
t[2][79] <= (((mult_out_20[79] + mult_out_21[79] + mult_out_22[79])%3329) + e_ntt[2][79])%3329;
t[2][80] <= (((mult_out_20[80] + mult_out_21[80] + mult_out_22[80])%3329) + e_ntt[2][80])%3329;
t[2][81] <= (((mult_out_20[81] + mult_out_21[81] + mult_out_22[81])%3329) + e_ntt[2][81])%3329;
t[2][82] <= (((mult_out_20[82] + mult_out_21[82] + mult_out_22[82])%3329) + e_ntt[2][82])%3329;
t[2][83] <= (((mult_out_20[83] + mult_out_21[83] + mult_out_22[83])%3329) + e_ntt[2][83])%3329;
t[2][84] <= (((mult_out_20[84] + mult_out_21[84] + mult_out_22[84])%3329) + e_ntt[2][84])%3329;
t[2][85] <= (((mult_out_20[85] + mult_out_21[85] + mult_out_22[85])%3329) + e_ntt[2][85])%3329;
t[2][86] <= (((mult_out_20[86] + mult_out_21[86] + mult_out_22[86])%3329) + e_ntt[2][86])%3329;
t[2][87] <= (((mult_out_20[87] + mult_out_21[87] + mult_out_22[87])%3329) + e_ntt[2][87])%3329;
t[2][88] <= (((mult_out_20[88] + mult_out_21[88] + mult_out_22[88])%3329) + e_ntt[2][88])%3329;
t[2][89] <= (((mult_out_20[89] + mult_out_21[89] + mult_out_22[89])%3329) + e_ntt[2][89])%3329;
t[2][90] <= (((mult_out_20[90] + mult_out_21[90] + mult_out_22[90])%3329) + e_ntt[2][90])%3329;
t[2][91] <= (((mult_out_20[91] + mult_out_21[91] + mult_out_22[91])%3329) + e_ntt[2][91])%3329;
t[2][92] <= (((mult_out_20[92] + mult_out_21[92] + mult_out_22[92])%3329) + e_ntt[2][92])%3329;
t[2][93] <= (((mult_out_20[93] + mult_out_21[93] + mult_out_22[93])%3329) + e_ntt[2][93])%3329;
t[2][94] <= (((mult_out_20[94] + mult_out_21[94] + mult_out_22[94])%3329) + e_ntt[2][94])%3329;
t[2][95] <= (((mult_out_20[95] + mult_out_21[95] + mult_out_22[95])%3329) + e_ntt[2][95])%3329;
t[2][96] <= (((mult_out_20[96] + mult_out_21[96] + mult_out_22[96])%3329) + e_ntt[2][96])%3329;
t[2][97] <= (((mult_out_20[97] + mult_out_21[97] + mult_out_22[97])%3329) + e_ntt[2][97])%3329;
t[2][98] <= (((mult_out_20[98] + mult_out_21[98] + mult_out_22[98])%3329) + e_ntt[2][98])%3329;
t[2][99] <= (((mult_out_20[99] + mult_out_21[99] + mult_out_22[99])%3329) + e_ntt[2][99])%3329;
t[2][100] <= (((mult_out_20[100] + mult_out_21[100] + mult_out_22[100])%3329) + e_ntt[2][100])%3329;
t[2][101] <= (((mult_out_20[101] + mult_out_21[101] + mult_out_22[101])%3329) + e_ntt[2][101])%3329;
t[2][102] <= (((mult_out_20[102] + mult_out_21[102] + mult_out_22[102])%3329) + e_ntt[2][102])%3329;
t[2][103] <= (((mult_out_20[103] + mult_out_21[103] + mult_out_22[103])%3329) + e_ntt[2][103])%3329;
t[2][104] <= (((mult_out_20[104] + mult_out_21[104] + mult_out_22[104])%3329) + e_ntt[2][104])%3329;
t[2][105] <= (((mult_out_20[105] + mult_out_21[105] + mult_out_22[105])%3329) + e_ntt[2][105])%3329;
t[2][106] <= (((mult_out_20[106] + mult_out_21[106] + mult_out_22[106])%3329) + e_ntt[2][106])%3329;
t[2][107] <= (((mult_out_20[107] + mult_out_21[107] + mult_out_22[107])%3329) + e_ntt[2][107])%3329;
t[2][108] <= (((mult_out_20[108] + mult_out_21[108] + mult_out_22[108])%3329) + e_ntt[2][108])%3329;
t[2][109] <= (((mult_out_20[109] + mult_out_21[109] + mult_out_22[109])%3329) + e_ntt[2][109])%3329;
t[2][110] <= (((mult_out_20[110] + mult_out_21[110] + mult_out_22[110])%3329) + e_ntt[2][110])%3329;
t[2][111] <= (((mult_out_20[111] + mult_out_21[111] + mult_out_22[111])%3329) + e_ntt[2][111])%3329;
t[2][112] <= (((mult_out_20[112] + mult_out_21[112] + mult_out_22[112])%3329) + e_ntt[2][112])%3329;
t[2][113] <= (((mult_out_20[113] + mult_out_21[113] + mult_out_22[113])%3329) + e_ntt[2][113])%3329;
t[2][114] <= (((mult_out_20[114] + mult_out_21[114] + mult_out_22[114])%3329) + e_ntt[2][114])%3329;
t[2][115] <= (((mult_out_20[115] + mult_out_21[115] + mult_out_22[115])%3329) + e_ntt[2][115])%3329;
t[2][116] <= (((mult_out_20[116] + mult_out_21[116] + mult_out_22[116])%3329) + e_ntt[2][116])%3329;
t[2][117] <= (((mult_out_20[117] + mult_out_21[117] + mult_out_22[117])%3329) + e_ntt[2][117])%3329;
t[2][118] <= (((mult_out_20[118] + mult_out_21[118] + mult_out_22[118])%3329) + e_ntt[2][118])%3329;
t[2][119] <= (((mult_out_20[119] + mult_out_21[119] + mult_out_22[119])%3329) + e_ntt[2][119])%3329;
t[2][120] <= (((mult_out_20[120] + mult_out_21[120] + mult_out_22[120])%3329) + e_ntt[2][120])%3329;
t[2][121] <= (((mult_out_20[121] + mult_out_21[121] + mult_out_22[121])%3329) + e_ntt[2][121])%3329;
t[2][122] <= (((mult_out_20[122] + mult_out_21[122] + mult_out_22[122])%3329) + e_ntt[2][122])%3329;
t[2][123] <= (((mult_out_20[123] + mult_out_21[123] + mult_out_22[123])%3329) + e_ntt[2][123])%3329;
t[2][124] <= (((mult_out_20[124] + mult_out_21[124] + mult_out_22[124])%3329) + e_ntt[2][124])%3329;
t[2][125] <= (((mult_out_20[125] + mult_out_21[125] + mult_out_22[125])%3329) + e_ntt[2][125])%3329;
t[2][126] <= (((mult_out_20[126] + mult_out_21[126] + mult_out_22[126])%3329) + e_ntt[2][126])%3329;
t[2][127] <= (((mult_out_20[127] + mult_out_21[127] + mult_out_22[127])%3329) + e_ntt[2][127])%3329;
t[2][128] <= (((mult_out_20[128] + mult_out_21[128] + mult_out_22[128])%3329) + e_ntt[2][128])%3329;
t[2][129] <= (((mult_out_20[129] + mult_out_21[129] + mult_out_22[129])%3329) + e_ntt[2][129])%3329;
t[2][130] <= (((mult_out_20[130] + mult_out_21[130] + mult_out_22[130])%3329) + e_ntt[2][130])%3329;
t[2][131] <= (((mult_out_20[131] + mult_out_21[131] + mult_out_22[131])%3329) + e_ntt[2][131])%3329;
t[2][132] <= (((mult_out_20[132] + mult_out_21[132] + mult_out_22[132])%3329) + e_ntt[2][132])%3329;
t[2][133] <= (((mult_out_20[133] + mult_out_21[133] + mult_out_22[133])%3329) + e_ntt[2][133])%3329;
t[2][134] <= (((mult_out_20[134] + mult_out_21[134] + mult_out_22[134])%3329) + e_ntt[2][134])%3329;
t[2][135] <= (((mult_out_20[135] + mult_out_21[135] + mult_out_22[135])%3329) + e_ntt[2][135])%3329;
t[2][136] <= (((mult_out_20[136] + mult_out_21[136] + mult_out_22[136])%3329) + e_ntt[2][136])%3329;
t[2][137] <= (((mult_out_20[137] + mult_out_21[137] + mult_out_22[137])%3329) + e_ntt[2][137])%3329;
t[2][138] <= (((mult_out_20[138] + mult_out_21[138] + mult_out_22[138])%3329) + e_ntt[2][138])%3329;
t[2][139] <= (((mult_out_20[139] + mult_out_21[139] + mult_out_22[139])%3329) + e_ntt[2][139])%3329;
t[2][140] <= (((mult_out_20[140] + mult_out_21[140] + mult_out_22[140])%3329) + e_ntt[2][140])%3329;
t[2][141] <= (((mult_out_20[141] + mult_out_21[141] + mult_out_22[141])%3329) + e_ntt[2][141])%3329;
t[2][142] <= (((mult_out_20[142] + mult_out_21[142] + mult_out_22[142])%3329) + e_ntt[2][142])%3329;
t[2][143] <= (((mult_out_20[143] + mult_out_21[143] + mult_out_22[143])%3329) + e_ntt[2][143])%3329;
t[2][144] <= (((mult_out_20[144] + mult_out_21[144] + mult_out_22[144])%3329) + e_ntt[2][144])%3329;
t[2][145] <= (((mult_out_20[145] + mult_out_21[145] + mult_out_22[145])%3329) + e_ntt[2][145])%3329;
t[2][146] <= (((mult_out_20[146] + mult_out_21[146] + mult_out_22[146])%3329) + e_ntt[2][146])%3329;
t[2][147] <= (((mult_out_20[147] + mult_out_21[147] + mult_out_22[147])%3329) + e_ntt[2][147])%3329;
t[2][148] <= (((mult_out_20[148] + mult_out_21[148] + mult_out_22[148])%3329) + e_ntt[2][148])%3329;
t[2][149] <= (((mult_out_20[149] + mult_out_21[149] + mult_out_22[149])%3329) + e_ntt[2][149])%3329;
t[2][150] <= (((mult_out_20[150] + mult_out_21[150] + mult_out_22[150])%3329) + e_ntt[2][150])%3329;
t[2][151] <= (((mult_out_20[151] + mult_out_21[151] + mult_out_22[151])%3329) + e_ntt[2][151])%3329;
t[2][152] <= (((mult_out_20[152] + mult_out_21[152] + mult_out_22[152])%3329) + e_ntt[2][152])%3329;
t[2][153] <= (((mult_out_20[153] + mult_out_21[153] + mult_out_22[153])%3329) + e_ntt[2][153])%3329;
t[2][154] <= (((mult_out_20[154] + mult_out_21[154] + mult_out_22[154])%3329) + e_ntt[2][154])%3329;
t[2][155] <= (((mult_out_20[155] + mult_out_21[155] + mult_out_22[155])%3329) + e_ntt[2][155])%3329;
t[2][156] <= (((mult_out_20[156] + mult_out_21[156] + mult_out_22[156])%3329) + e_ntt[2][156])%3329;
t[2][157] <= (((mult_out_20[157] + mult_out_21[157] + mult_out_22[157])%3329) + e_ntt[2][157])%3329;
t[2][158] <= (((mult_out_20[158] + mult_out_21[158] + mult_out_22[158])%3329) + e_ntt[2][158])%3329;
t[2][159] <= (((mult_out_20[159] + mult_out_21[159] + mult_out_22[159])%3329) + e_ntt[2][159])%3329;
t[2][160] <= (((mult_out_20[160] + mult_out_21[160] + mult_out_22[160])%3329) + e_ntt[2][160])%3329;
t[2][161] <= (((mult_out_20[161] + mult_out_21[161] + mult_out_22[161])%3329) + e_ntt[2][161])%3329;
t[2][162] <= (((mult_out_20[162] + mult_out_21[162] + mult_out_22[162])%3329) + e_ntt[2][162])%3329;
t[2][163] <= (((mult_out_20[163] + mult_out_21[163] + mult_out_22[163])%3329) + e_ntt[2][163])%3329;
t[2][164] <= (((mult_out_20[164] + mult_out_21[164] + mult_out_22[164])%3329) + e_ntt[2][164])%3329;
t[2][165] <= (((mult_out_20[165] + mult_out_21[165] + mult_out_22[165])%3329) + e_ntt[2][165])%3329;
t[2][166] <= (((mult_out_20[166] + mult_out_21[166] + mult_out_22[166])%3329) + e_ntt[2][166])%3329;
t[2][167] <= (((mult_out_20[167] + mult_out_21[167] + mult_out_22[167])%3329) + e_ntt[2][167])%3329;
t[2][168] <= (((mult_out_20[168] + mult_out_21[168] + mult_out_22[168])%3329) + e_ntt[2][168])%3329;
t[2][169] <= (((mult_out_20[169] + mult_out_21[169] + mult_out_22[169])%3329) + e_ntt[2][169])%3329;
t[2][170] <= (((mult_out_20[170] + mult_out_21[170] + mult_out_22[170])%3329) + e_ntt[2][170])%3329;
t[2][171] <= (((mult_out_20[171] + mult_out_21[171] + mult_out_22[171])%3329) + e_ntt[2][171])%3329;
t[2][172] <= (((mult_out_20[172] + mult_out_21[172] + mult_out_22[172])%3329) + e_ntt[2][172])%3329;
t[2][173] <= (((mult_out_20[173] + mult_out_21[173] + mult_out_22[173])%3329) + e_ntt[2][173])%3329;
t[2][174] <= (((mult_out_20[174] + mult_out_21[174] + mult_out_22[174])%3329) + e_ntt[2][174])%3329;
t[2][175] <= (((mult_out_20[175] + mult_out_21[175] + mult_out_22[175])%3329) + e_ntt[2][175])%3329;
t[2][176] <= (((mult_out_20[176] + mult_out_21[176] + mult_out_22[176])%3329) + e_ntt[2][176])%3329;
t[2][177] <= (((mult_out_20[177] + mult_out_21[177] + mult_out_22[177])%3329) + e_ntt[2][177])%3329;
t[2][178] <= (((mult_out_20[178] + mult_out_21[178] + mult_out_22[178])%3329) + e_ntt[2][178])%3329;
t[2][179] <= (((mult_out_20[179] + mult_out_21[179] + mult_out_22[179])%3329) + e_ntt[2][179])%3329;
t[2][180] <= (((mult_out_20[180] + mult_out_21[180] + mult_out_22[180])%3329) + e_ntt[2][180])%3329;
t[2][181] <= (((mult_out_20[181] + mult_out_21[181] + mult_out_22[181])%3329) + e_ntt[2][181])%3329;
t[2][182] <= (((mult_out_20[182] + mult_out_21[182] + mult_out_22[182])%3329) + e_ntt[2][182])%3329;
t[2][183] <= (((mult_out_20[183] + mult_out_21[183] + mult_out_22[183])%3329) + e_ntt[2][183])%3329;
t[2][184] <= (((mult_out_20[184] + mult_out_21[184] + mult_out_22[184])%3329) + e_ntt[2][184])%3329;
t[2][185] <= (((mult_out_20[185] + mult_out_21[185] + mult_out_22[185])%3329) + e_ntt[2][185])%3329;
t[2][186] <= (((mult_out_20[186] + mult_out_21[186] + mult_out_22[186])%3329) + e_ntt[2][186])%3329;
t[2][187] <= (((mult_out_20[187] + mult_out_21[187] + mult_out_22[187])%3329) + e_ntt[2][187])%3329;
t[2][188] <= (((mult_out_20[188] + mult_out_21[188] + mult_out_22[188])%3329) + e_ntt[2][188])%3329;
t[2][189] <= (((mult_out_20[189] + mult_out_21[189] + mult_out_22[189])%3329) + e_ntt[2][189])%3329;
t[2][190] <= (((mult_out_20[190] + mult_out_21[190] + mult_out_22[190])%3329) + e_ntt[2][190])%3329;
t[2][191] <= (((mult_out_20[191] + mult_out_21[191] + mult_out_22[191])%3329) + e_ntt[2][191])%3329;
t[2][192] <= (((mult_out_20[192] + mult_out_21[192] + mult_out_22[192])%3329) + e_ntt[2][192])%3329;
t[2][193] <= (((mult_out_20[193] + mult_out_21[193] + mult_out_22[193])%3329) + e_ntt[2][193])%3329;
t[2][194] <= (((mult_out_20[194] + mult_out_21[194] + mult_out_22[194])%3329) + e_ntt[2][194])%3329;
t[2][195] <= (((mult_out_20[195] + mult_out_21[195] + mult_out_22[195])%3329) + e_ntt[2][195])%3329;
t[2][196] <= (((mult_out_20[196] + mult_out_21[196] + mult_out_22[196])%3329) + e_ntt[2][196])%3329;
t[2][197] <= (((mult_out_20[197] + mult_out_21[197] + mult_out_22[197])%3329) + e_ntt[2][197])%3329;
t[2][198] <= (((mult_out_20[198] + mult_out_21[198] + mult_out_22[198])%3329) + e_ntt[2][198])%3329;
t[2][199] <= (((mult_out_20[199] + mult_out_21[199] + mult_out_22[199])%3329) + e_ntt[2][199])%3329;
t[2][200] <= (((mult_out_20[200] + mult_out_21[200] + mult_out_22[200])%3329) + e_ntt[2][200])%3329;
t[2][201] <= (((mult_out_20[201] + mult_out_21[201] + mult_out_22[201])%3329) + e_ntt[2][201])%3329;
t[2][202] <= (((mult_out_20[202] + mult_out_21[202] + mult_out_22[202])%3329) + e_ntt[2][202])%3329;
t[2][203] <= (((mult_out_20[203] + mult_out_21[203] + mult_out_22[203])%3329) + e_ntt[2][203])%3329;
t[2][204] <= (((mult_out_20[204] + mult_out_21[204] + mult_out_22[204])%3329) + e_ntt[2][204])%3329;
t[2][205] <= (((mult_out_20[205] + mult_out_21[205] + mult_out_22[205])%3329) + e_ntt[2][205])%3329;
t[2][206] <= (((mult_out_20[206] + mult_out_21[206] + mult_out_22[206])%3329) + e_ntt[2][206])%3329;
t[2][207] <= (((mult_out_20[207] + mult_out_21[207] + mult_out_22[207])%3329) + e_ntt[2][207])%3329;
t[2][208] <= (((mult_out_20[208] + mult_out_21[208] + mult_out_22[208])%3329) + e_ntt[2][208])%3329;
t[2][209] <= (((mult_out_20[209] + mult_out_21[209] + mult_out_22[209])%3329) + e_ntt[2][209])%3329;
t[2][210] <= (((mult_out_20[210] + mult_out_21[210] + mult_out_22[210])%3329) + e_ntt[2][210])%3329;
t[2][211] <= (((mult_out_20[211] + mult_out_21[211] + mult_out_22[211])%3329) + e_ntt[2][211])%3329;
t[2][212] <= (((mult_out_20[212] + mult_out_21[212] + mult_out_22[212])%3329) + e_ntt[2][212])%3329;
t[2][213] <= (((mult_out_20[213] + mult_out_21[213] + mult_out_22[213])%3329) + e_ntt[2][213])%3329;
t[2][214] <= (((mult_out_20[214] + mult_out_21[214] + mult_out_22[214])%3329) + e_ntt[2][214])%3329;
t[2][215] <= (((mult_out_20[215] + mult_out_21[215] + mult_out_22[215])%3329) + e_ntt[2][215])%3329;
t[2][216] <= (((mult_out_20[216] + mult_out_21[216] + mult_out_22[216])%3329) + e_ntt[2][216])%3329;
t[2][217] <= (((mult_out_20[217] + mult_out_21[217] + mult_out_22[217])%3329) + e_ntt[2][217])%3329;
t[2][218] <= (((mult_out_20[218] + mult_out_21[218] + mult_out_22[218])%3329) + e_ntt[2][218])%3329;
t[2][219] <= (((mult_out_20[219] + mult_out_21[219] + mult_out_22[219])%3329) + e_ntt[2][219])%3329;
t[2][220] <= (((mult_out_20[220] + mult_out_21[220] + mult_out_22[220])%3329) + e_ntt[2][220])%3329;
t[2][221] <= (((mult_out_20[221] + mult_out_21[221] + mult_out_22[221])%3329) + e_ntt[2][221])%3329;
t[2][222] <= (((mult_out_20[222] + mult_out_21[222] + mult_out_22[222])%3329) + e_ntt[2][222])%3329;
t[2][223] <= (((mult_out_20[223] + mult_out_21[223] + mult_out_22[223])%3329) + e_ntt[2][223])%3329;
t[2][224] <= (((mult_out_20[224] + mult_out_21[224] + mult_out_22[224])%3329) + e_ntt[2][224])%3329;
t[2][225] <= (((mult_out_20[225] + mult_out_21[225] + mult_out_22[225])%3329) + e_ntt[2][225])%3329;
t[2][226] <= (((mult_out_20[226] + mult_out_21[226] + mult_out_22[226])%3329) + e_ntt[2][226])%3329;
t[2][227] <= (((mult_out_20[227] + mult_out_21[227] + mult_out_22[227])%3329) + e_ntt[2][227])%3329;
t[2][228] <= (((mult_out_20[228] + mult_out_21[228] + mult_out_22[228])%3329) + e_ntt[2][228])%3329;
t[2][229] <= (((mult_out_20[229] + mult_out_21[229] + mult_out_22[229])%3329) + e_ntt[2][229])%3329;
t[2][230] <= (((mult_out_20[230] + mult_out_21[230] + mult_out_22[230])%3329) + e_ntt[2][230])%3329;
t[2][231] <= (((mult_out_20[231] + mult_out_21[231] + mult_out_22[231])%3329) + e_ntt[2][231])%3329;
t[2][232] <= (((mult_out_20[232] + mult_out_21[232] + mult_out_22[232])%3329) + e_ntt[2][232])%3329;
t[2][233] <= (((mult_out_20[233] + mult_out_21[233] + mult_out_22[233])%3329) + e_ntt[2][233])%3329;
t[2][234] <= (((mult_out_20[234] + mult_out_21[234] + mult_out_22[234])%3329) + e_ntt[2][234])%3329;
t[2][235] <= (((mult_out_20[235] + mult_out_21[235] + mult_out_22[235])%3329) + e_ntt[2][235])%3329;
t[2][236] <= (((mult_out_20[236] + mult_out_21[236] + mult_out_22[236])%3329) + e_ntt[2][236])%3329;
t[2][237] <= (((mult_out_20[237] + mult_out_21[237] + mult_out_22[237])%3329) + e_ntt[2][237])%3329;
t[2][238] <= (((mult_out_20[238] + mult_out_21[238] + mult_out_22[238])%3329) + e_ntt[2][238])%3329;
t[2][239] <= (((mult_out_20[239] + mult_out_21[239] + mult_out_22[239])%3329) + e_ntt[2][239])%3329;
t[2][240] <= (((mult_out_20[240] + mult_out_21[240] + mult_out_22[240])%3329) + e_ntt[2][240])%3329;
t[2][241] <= (((mult_out_20[241] + mult_out_21[241] + mult_out_22[241])%3329) + e_ntt[2][241])%3329;
t[2][242] <= (((mult_out_20[242] + mult_out_21[242] + mult_out_22[242])%3329) + e_ntt[2][242])%3329;
t[2][243] <= (((mult_out_20[243] + mult_out_21[243] + mult_out_22[243])%3329) + e_ntt[2][243])%3329;
t[2][244] <= (((mult_out_20[244] + mult_out_21[244] + mult_out_22[244])%3329) + e_ntt[2][244])%3329;
t[2][245] <= (((mult_out_20[245] + mult_out_21[245] + mult_out_22[245])%3329) + e_ntt[2][245])%3329;
t[2][246] <= (((mult_out_20[246] + mult_out_21[246] + mult_out_22[246])%3329) + e_ntt[2][246])%3329;
t[2][247] <= (((mult_out_20[247] + mult_out_21[247] + mult_out_22[247])%3329) + e_ntt[2][247])%3329;
t[2][248] <= (((mult_out_20[248] + mult_out_21[248] + mult_out_22[248])%3329) + e_ntt[2][248])%3329;
t[2][249] <= (((mult_out_20[249] + mult_out_21[249] + mult_out_22[249])%3329) + e_ntt[2][249])%3329;
t[2][250] <= (((mult_out_20[250] + mult_out_21[250] + mult_out_22[250])%3329) + e_ntt[2][250])%3329;
t[2][251] <= (((mult_out_20[251] + mult_out_21[251] + mult_out_22[251])%3329) + e_ntt[2][251])%3329;
t[2][252] <= (((mult_out_20[252] + mult_out_21[252] + mult_out_22[252])%3329) + e_ntt[2][252])%3329;
t[2][253] <= (((mult_out_20[253] + mult_out_21[253] + mult_out_22[253])%3329) + e_ntt[2][253])%3329;
t[2][254] <= (((mult_out_20[254] + mult_out_21[254] + mult_out_22[254])%3329) + e_ntt[2][254])%3329;
t[2][255] <= (((mult_out_20[255] + mult_out_21[255] + mult_out_22[255])%3329) + e_ntt[2][255])%3329;

                                                         start_encode<=1;
//                                                         done_check <= start_encode;
                                                         end
                                                         
                                                         if(done0_encode && done1_encode && done2_encode && done3_encode && done4_encode && done5_encode) begin
//                                                         start_encode <= 1'b0;
                                                         done <= 1'b1;
                                                         
                                                         end
                                                         
                                      
           end
       end
////    // Byte Encoding
//////    ByteEncode_12 enc_t (.input_data(t), .output_data(ek_PKE));
        // Byte Encoding for ek_PKE (each index is 384 bytes)

////    ByteEncode_12 enc_t0 (.input_data(t[0]), .output_data(ek_PKE_parts[0]));
////    ByteEncode_12 enc_t1 (.input_data(t[1]), .output_data(ek_PKE_parts[1]));
////    ByteEncode_12 enc_t2 (.input_data(t[2]), .output_data(ek_PKE_parts[2]));

////    assign ek_PKE = {ek_PKE_parts[0], ek_PKE_parts[1], ek_PKE_parts[2], rho};  // Concatenation

////    logic [3071:0] sk_SKE_parts [0:2]; // 384 bytes (3072 bits) per index

////    ByteEncode_12 enc_s0 (.input_data(s_ntt[0]), .output_data(sk_SKE_parts[0]));
////    ByteEncode_12 enc_s1 (.input_data(s_ntt[1]), .output_data(sk_SKE_parts[1]));
////    ByteEncode_12 enc_s2 (.input_data(s_ntt[2]), .output_data(sk_SKE_parts[2]));

////    assign sk_PKE = {sk_SKE_parts[0], sk_SKE_parts[1], sk_SKE_parts[2]};
//assign done = 1'b1;
endmodule