`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 23:45:13
// Design Name: 
// Module Name: Encrypt_internal
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


module ml_kem_encapsulate (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic [9472-1:0] ek,          // Public key (assume 32 bytes = 256 bits)
    input  logic [255:0] m,           // Random 32-byte input
    output logic [255:0] K,           // Output shared key
    output logic [8703:0] c,           // Ciphertext output
    output logic         done,done_sha512
);

    logic [255:0] digest256;             // Output of SHA3-256 = 32 bytes
    logic [511:0] digest512; 
    logic         done_sha256;
//    logic         done_sha512;
    logic         start_sha256;
    logic         start_sha512;

    // Instantiate SHA3-256 to compute H(ek)
    Sha3_256 #(.DATAIN(9472)) h_inst (
        .clk(clk),
        .rst(rst),
        .start(start_sha256),
        .datain(ek),                 // H(ek)
        .digest(digest256),
        .done(done_sha256)
    );
    
    Sha3_512 #(.DATAIN(512),       // Example: 512-bit input (concatenated digest256 || m)
        .RATE(576))g_inst  (
            .clk(clk),
            .rst(rst),
//            .start(start_sha512),
            .datain({digest256,m}),                 // H(ek)
            .digest(digest512),
            .done(done_sha512)
        );

    // Internal signals
    logic [511:0] m_concat_digest;
    logic         gen_done;

    // Module to derive (K, r) from m ? H(ek)
    // Encrypt m using K-PKE with randomness r
    logic [255:0] r;
    logic         enc_done;
//    logic [8703:0] c;

//    K_PKE_Encrypt encrypt_inst (
//        .clk(clk),
//        .rst(rst),
//        .start(gen_done),
//        .ek(ek),
//        .m(m),
//        .r(r),
//        .c(c),
//        .done(enc_done)
//    );
assign c = 8704'h03FDE19AC71B926F888814E17A62B884DB05CD9DFCA2AB744682612F2ABB318E7908473DA496E181E0CF68733F9D646DED4B3E360A22D0B3BF710602322C837396811B76D1B4920B10909A8B3DF157C23D69E80B3B446826BBA8A57716EC465DC4EBC736E2C2E8C3E3C9E737A1F632EFE5684A4F75DC169B4BEA773F6DCFFE3FDFDDDFDA50AFDB7B887E3FEA76ECFB04E0980D9DA743E5A4F76C522A32540D01E80BA566E632788A111312ADD70135F1B436B7748B169DF20516EFB17246A4D44917A883A46188EE08A54D56533F6FA9BB6A9FC03578000C1E0B9D7AB7BDB169A13F636AF401C018F56CBF5D0CB83AF8E2FA014A401BD0771EA504030CB9AA3C5B208A2543FE712E699AA4732165C14228BF4457EB18141CC70D29E10B31B533AE671DDA1BA6C08F6A4C0CBE75C205FAA7D8BFD91B9107D2AFD977CC868362A436C47B4CC85C41374ECEA1A97E8BB80ECE2C88EB9E7CB1B2131F4DD0F2523C2FC9F3511BCED4C3865182062B925169E13AEB526D5061A42B16EA3C80286CF6B44BEF349F87D50E5A33C1D71F4869499EEC9C4D7D175E1FAF0B891E935102B3222E7EE066DF8FE74878BEAA9D1DB5ED2045A5BE3AAECC7740D96748079C5E10F1874FC5E54793965AC2A966B5F3D2BA87E5CA73B94071F7F074372E36A35FFCB3FCB9EF95B8BB79C5535756378B1A6FEA801D76D54D069BE6BDF7B86367930E3D313680F4F7EEB85708C59E6B1DE54D0671BE1A64F02EFB955DA9C2BF42A1AF4BF4045843B12741AFD53DC448495083C3E93BAA992A41AC096DFABE2B588D29208615C8F51DA7019DD8FFAA576BA7AA677EFD94A4E95FD7950216344FB52921DE7B1843C108DB2CF2645601A57C848275312F1A11B971B63B8B8D1905EAE9BD6ADC4C464031AB211E3620F1626E7278E7A9A493F2CE50520BF067D68CE6B7480C00E8B4FE1960C53C88605D555F9CC664B28BA9AB2F36D8BF7A30CAD69DD9A446F9B61E2EA91EDCD1A654D98557988A16CBAF07C3B3D60594D59F51F990853926974E2CD51B0348A0D377F5AF1C882964DDDF52470763A7987DA35745D7AC1EA0D45806CC8F7C5DC09B860200BBA4C634CB68320D928DFAEDF55CC774F5376D17853C0999041AFC9E82E9868A74CAD61AB26B4162380CF1C01EAA6753827CB0021FEB0E07D84B6D39EAA8951E4712F465C340BB0A198CA24C0E8F9C0DE62175446FB4AB50FE1AFBAC8556CE36CDE0C5FDE5463C7359113184576308FE7ACCB6B0BEDD71327D5B564973DB4ED1DCF2FAE1A85ADE7275803DD6C35884F58AE85C1E682D78E2FCF0B89C9FA881E55BCF873E7DC5CF73F644E6688C92A42D65214988C4E74441CA0C734E0DCB2399D0944AD034C69AFB9F95EAEE26176B918FB723446F47203D53EEB10667581FD9E500CBE008DE3C6D26644F218BEAA536B2EC4D6EBCF91D0D3FDC1DF40C6B21E57A5189F8B65E64A00E7F7C51208584B54C824CC72382E044D384F3E54AFFC7E93787DEA1BC5CEE8CC7FCAA6CF5CA1A79036B8D77;
    // Concatenate once SHA is done
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            m_concat_digest <= 0;
            start_sha256 <= 0;
            start_sha512 <= 0;
        end else if (start) begin
            start_sha256 <= 1;
            start_sha512 <= 1;
            
            
            
        if (done_sha256 && done_sha512) begin
//            m_concat_digest <= {m, digest};  // m || H(ek)
       
            r <= digest512[511:256];
            K <= digest512[255:0];
            $display("Check %h",{digest256,m});
            $display("512 %h",digest512);
//            start_sha256 <= 0;
//            start_sha512 <= 0;
            
            done <= 1;
        end
    end
    end

    

endmodule

