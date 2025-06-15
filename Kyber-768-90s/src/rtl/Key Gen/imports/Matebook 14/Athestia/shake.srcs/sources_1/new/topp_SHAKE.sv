`timescale 1ns / 1ps


module topp_SHAKE(    
    input logic clk,
    input logic rst,
    output logic led
   );
   
   logic [276-1:0] datain;
   logic [6144-1:0] digest;
   logic [6144-1:0] check;
   assign datain = 276'hF9A897867564534231201F0DEBC9A78563412908F7E6D5C4B3A291807F6E5D4C3B2A1;
   assign check = 6144'hfd4ad18fcc994b6ad3011ca08955d3a9ba98dedee744a76b9b34afe3320346ea4110c8c0b7f15ccdc6d726f1857a419b755a41df32357c4ca264a4b7e4ffc340214d39136c64a92410ca5ecfdbd277ff1189c32f98b597215ffc91c388333966df596dbb02abd627b16372161787e278e68d5e6c79ba59e9bfbc250f488f28ff325b0c0266769e34e97da7344003f685c55a3dec476f5a2c84b3a1dc2bdb9a8c5dfc639fbc7949fb640d59ad20967505b20cbba99be7b32ec2386ad744459dab043cc6cbdbca5b4031a045e932e5f707a1ef8a3a438d1ef4fc3ff4aa3bf6de3cd48a1684f9b86de1d5170b73db3c2e2c27018e74762690a5bace3efd3a857db6cef64ea050c03b2298164bace700e35721fef563122f6e849232c1045936b20dfa8362f2b397873e4453a09984736a947df50d6bbec9087ea6853650fe3692ba763ec3a886f42257b8fcd8ca1a5e34f9838fc1e27ba8314742459a9a3d09183ef3a26b7b4d755a6d114eb5480fd55ea0146efb5fd44a602ff9d28bdb80b7ce5c160b7686fc3591739d6464892f5e07efdcb92deb68c64f8d58b44c3c3e1d53170619aa63aa6bbe2f2986cd97656f5fef81281a6626370d996a0ba205f1d73c4289f99303881eaedad6277d6b6445d4083d4deddd5ffb39b493c3a0bbef581a9356369c04c8de39456c75cdea0eb641838d2a61a378a814351ca2cc0e8cb6f9343b517ee18d5ddcb735ab24f2fef4a8813f0499abb19d1e981da46b149bf5b2c0fe9d1b6a66abcd7ec2e70c7cb468048421f03e30ae9758017ee2bea1b6441e76d4ee7360404e1d8d2454c3b0387b0d20f9fd0bbfaf2a5ea7c0408d990d01e3abd5f403294c8ec2608df2f65f31a4d12c3cf0a6295a53e271cd9ab51fc41485ed9ccb226f77c0ec06960e900eaa35fcd9b3878863c687a244fa0b24cf3637bb4f668b223e7cefef21112a6cb0725ac8d53d34aecd0bc2dfa02e79f377d244ecb04ad31fe485d56364f54146915a02cd489a51d047a1d08d988464b08277512f32424e5612dd074d6447d7a00f1f3aec1fdae69e6d51487aa028a56064a4ed7cbc;
//   assign datain = 120'h726E676A6A656A6A726A676A657268 ;
//   assign check = 256'hdfde6395b8647257f66c3ccffd567170e6c6b76811cb0293679d459d3d5e976e ;

   
   sponge #(
    .msg_len(276),
    .d_len(6144),
    .capacity(256),
    .r(1600 - 256)
) shake(
       .clk(clk),
       .reset(rst),
       .start(1'b1),
       .message(datain),
       .z(digest)
   );
   
   always_ff @(posedge clk)begin
     if (digest == check) begin
            led <= 1'b1;  // Assign 1 to 'led'
        end
        else begin
            led <= 1'b0;  // Assign 0 to 'led'
        end
   end
//   assign led = digest[0:5];
endmodule