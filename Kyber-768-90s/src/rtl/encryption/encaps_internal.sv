`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2025 12:02:22 PM
// Design Name: 
// Module Name: encaps_internal
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

module encaps_internal (
    input  logic         clk,
    input  logic         rst,
    input logic [7:0] ek[1183:0],          // Public key (assume 32 bytes = 256 bits)
    input   logic [7:0] mess [32-1:0],
     input  logic         start,           // Random 32-byte input
    output logic [255:0] K,           // Output shared key
    output logic [7:0] c [1088-1:0],           // Ciphertext output
   output logic         done
);

    logic [255:0] digest256;             // Output of SHA3-256 = 32 bytes
    logic [511:0] digest512; 
    logic         done_sha256;
    logic         done_sha512;
    logic         start_sha256;
    logic         start_sha512;
    logic [9472-1:0] ek1;
    logic [255:0] m;
//    assign m = 255'hC4948398E2ECDF93F3A019424A5771BB893D9D3FC8D0493DA79C6EC1CA9DBE40;
    // Instantiate SHA3-256 to compute H(ek)
    Sha3_256 #(.DATAIN(9472)) h_inst (
        .clk(clk),
        .rst(rst),
        .start(start_sha256),
        .datain(ek1),                 // H(ek)
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
//    assign ek1 = 9472'ha8e651a1e685f22478a8954f007bc7711b930772c78f092e82878e3e937f367967532913a8d53dfdf4bfb1f8846746596705cf345142b972a3f16325c40c2952a37b25897e5ef35fbaeb73a4acbeb6a0b89942ceb195531cfc0a07993954483e6cbc87c06aa74ff0cac5207e535b260aa98d1198c07da605c4d11020f6c9f7bb68bb3456c73a01b710bc99d17739a51716aa01660c8b628b2f5602ba65f07ea993336e896e83f2c5731bbf03460c5b6c8afecb748ee391e98934a2c57d4d069f50d88b30d6966f38c37bc649b82634ce7722645ccd625063364646d6d699db57b45eb67465e16de4d406a818b9eae1ca916a2594489708a43cea88b02a4c03d09b44815c97101caf5048bbcb247ae2366cdc254ba22129f45b3b0eb399ca91a303402830ec01db7b2ca480cf350409b216094b7b0c3ae33ce10a9124e89651ab901ea253c8415bd7825f02bb229369af972028f22875ea55af16d3bc69f70c2ee8b75f28b47dd391f989ade314729c331fa04c1917b278c3eb602868512821adc825c64577ce1e63b1d9644a612948a3483c7f1b9a258000e30196944a403627609c76c7ea6b5de01764d24379117b9ea29848dc555c454bceae1ba5cc72c74ab96b9c91b910d26b88b25639d4778ae26c7c6151a19c6cd7938454372465e4c5ec29245acb3db5379de3dabfa629a7c04a8353a8530c95acb732bb4bb81932bb2ca7a848cd366801444abe23c83b366a87d6a3cf360924c002bae90af65c48060b3752f2badf1ab2722072554a5059753594e6a702761fc97684c8c4a7540a6b07fbc9de87c974aa8809d928c7f4cbbf8045aea5bc667825fd05a521f1a4bf539210c7113bc37b3e58b0cbfc53c841cbb0371de2e511b989cb7c70c023366d78f9c37ef047f8720be1c759a8d96b93f65a94114ffaf60d9a81795e995c71152a4691a5a602a9e1f3599e37c768c7bc108994c0669f3adc957d46b4b6256968e290d7892ea85464ee7a750f39c5e3152c2dfc56d8b0c924ba8a959a68096547f66423c838982a5794b9e1533771331a9a656c28828beb9126a60e95e8c5d906832c7710705576b1fb9507269ddaf8c95ce9719b2ca8dd112be10bcc9f4a37bd1b1eeeb33ecda76ae9f69a5d4b2923a86957671d619335be1c4c2c77ce87c41f98a8cc466460fa300aaf5b301f0a1d09c88e65da4d8ee64f68c02189bbb3584baff716c85db654048a004333489393a07427cd3e217e6a345f6c2c2b13c27b337271c0b27b2dbaa00d237600b5b594e8cf2dd625ea76cf0ed899122c9796b4b0187004258049a477cd11d68c49b9a0e7b00bce8cac7864cbb375140084744c93062694ca795c4f40e7acc9c5a1884072d8c38dafb501ee4184dd5a819ec24ec1651261f962b17a7215aa4a748c15836c389137678204838d7195a85b4f98a1b574c4cd7909cd1f833effd1485543229d3748d9b5cd6c17b9b3b84aef8bce13e683733659c79542d615782a71cdeee792bab51bdc4bbfe8308e663144ede8491830ad98b4634f64aba8b9c042272653920f380c1a17ca87ced7aac41c82888793181a6f76e197b7b90ef90943bb3844912911d8551e5466c5767ab0bc61a1a3f736162ec098a900b12dd8fabbfb3fe8cb1dc4e8315f2af0d32f0017ae136e19f028;

    // Module to derive (K, r) from m ? H(ek)
    // Encrypt m using K-PKE with randomness r
    logic [255:0] r;
    logic         enc_done;
//    logic [8703:0] c;

    encryption #( .k(3),.ELL(16),.NUM_COEFFS(256),.Q(3329)
)encrypt_inst  (
 .clk(clk),
  .rst(rst),
  .pk(ek),    
  .mess(mess), 
  .r(r),  
  .encode_all(c)
    );
//assign c = 8704'h03FDE19AC71B926F888814E17A62B884DB05CD9DFCA2AB744682612F2ABB318E7908473DA496E181E0CF68733F9D646DED4B3E360A22D0B3BF710602322C837396811B76D1B4920B10909A8B3DF157C23D69E80B3B446826BBA8A57716EC465DC4EBC736E2C2E8C3E3C9E737A1F632EFE5684A4F75DC169B4BEA773F6DCFFE3FDFDDDFDA50AFDB7B887E3FEA76ECFB04E0980D9DA743E5A4F76C522A32540D01E80BA566E632788A111312ADD70135F1B436B7748B169DF20516EFB17246A4D44917A883A46188EE08A54D56533F6FA9BB6A9FC03578000C1E0B9D7AB7BDB169A13F636AF401C018F56CBF5D0CB83AF8E2FA014A401BD0771EA504030CB9AA3C5B208A2543FE712E699AA4732165C14228BF4457EB18141CC70D29E10B31B533AE671DDA1BA6C08F6A4C0CBE75C205FAA7D8BFD91B9107D2AFD977CC868362A436C47B4CC85C41374ECEA1A97E8BB80ECE2C88EB9E7CB1B2131F4DD0F2523C2FC9F3511BCED4C3865182062B925169E13AEB526D5061A42B16EA3C80286CF6B44BEF349F87D50E5A33C1D71F4869499EEC9C4D7D175E1FAF0B891E935102B3222E7EE066DF8FE74878BEAA9D1DB5ED2045A5BE3AAECC7740D96748079C5E10F1874FC5E54793965AC2A966B5F3D2BA87E5CA73B94071F7F074372E36A35FFCB3FCB9EF95B8BB79C5535756378B1A6FEA801D76D54D069BE6BDF7B86367930E3D313680F4F7EEB85708C59E6B1DE54D0671BE1A64F02EFB955DA9C2BF42A1AF4BF4045843B12741AFD53DC448495083C3E93BAA992A41AC096DFABE2B588D29208615C8F51DA7019DD8FFAA576BA7AA677EFD94A4E95FD7950216344FB52921DE7B1843C108DB2CF2645601A57C848275312F1A11B971B63B8B8D1905EAE9BD6ADC4C464031AB211E3620F1626E7278E7A9A493F2CE50520BF067D68CE6B7480C00E8B4FE1960C53C88605D555F9CC664B28BA9AB2F36D8BF7A30CAD69DD9A446F9B61E2EA91EDCD1A654D98557988A16CBAF07C3B3D60594D59F51F990853926974E2CD51B0348A0D377F5AF1C882964DDDF52470763A7987DA35745D7AC1EA0D45806CC8F7C5DC09B860200BBA4C634CB68320D928DFAEDF55CC774F5376D17853C0999041AFC9E82E9868A74CAD61AB26B4162380CF1C01EAA6753827CB0021FEB0E07D84B6D39EAA8951E4712F465C340BB0A198CA24C0E8F9C0DE62175446FB4AB50FE1AFBAC8556CE36CDE0C5FDE5463C7359113184576308FE7ACCB6B0BEDD71327D5B564973DB4ED1DCF2FAE1A85ADE7275803DD6C35884F58AE85C1E682D78E2FCF0B89C9FA881E55BCF873E7DC5CF73F644E6688C92A42D65214988C4E74441CA0C734E0DCB2399D0944AD034C69AFB9F95EAEE26176B918FB723446F47203D53EEB10667581FD9E500CBE008DE3C6D26644F218BEAA536B2EC4D6EBCF91D0D3FDC1DF40C6B21E57A5189F8B65E64A00E7F7C51208584B54C824CC72382E044D384F3E54AFFC7E93787DEA1BC5CEE8CC7FCAA6CF5CA1A79036B8D77;
    // Concatenate once SHA is done
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            m_concat_digest <= 0;
            start_sha256 <= 0;
            start_sha512 <= 0;
        end else if (start) begin
            start_sha256 <= 1;
            start_sha512 <= 1;
            
            
            
        if (done_sha256 ) begin
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