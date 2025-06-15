`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2024 05:04:28 PM
// Design Name: 
// Module Name: topp
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


module topp(    
    input logic clk,
    input logic rst,
    output logic led
   );
   
   logic [2319:0] datain;
   logic [0:255] digest;
   logic [0:255] check;
   assign datain = 2320'h2E6E6F6974636E7566206873616820636968706172676F74707972632061207369202933206D687469726F676C412068736148206572756365532820332D4148532E737469622036353220332D616873206E6F20676E696B726F7720796C746E65727275632065726577206557202E796C696D616620332D4148532065687420666F2074726170207361202979676F6C6F6E6863655420646E612073647261646E61745320666F20657475746974736E49206C616E6F6974614E28205453494E2079622035313032206E692064657A69647261646E617473207361772074616874206E6F6974636E7566206873616820636968706172676F74707972632061207369202933206D687469726F676C412068736148206572756365532820332D414853;
   assign check = 256'h4e628a34ecba2dc466e17c283d8dc551b489f293c7cf3ed76cc86747d2ece221;

//   assign datain = 120'h726E676A6A656A6A726A676A657268 ;
//   assign check = 256'hdfde6395b8647257f66c3ccffd567170e6c6b76811cb0293679d459d3d5e976e ;

   
   Sha3_256 u_sha(
       .clk(clk),
       .rst(rst),
       .datain(datain),
       .digest(digest)
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
