`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2024 12:02:18 PM
// Design Name: 
// Module Name: Pi
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


module Pi(
    input logic[63:0] rho_in [0:4][0:4],
    output logic [63:0] pi [0:4][0:4]
    );
    
  always_comb begin
  //ROW_1
    pi[0][0] = rho_in[0][0];
    pi[0][1] = rho_in[3][0];
    pi[0][2] = rho_in[1][0];
    pi[0][3] = rho_in[4][0];
    pi[0][4] = rho_in[2][0];
  
  //ROW_2
    pi[1][0] = rho_in[1][1];
    pi[1][1] = rho_in[4][1];
    pi[1][2] = rho_in[2][1];
    pi[1][3] = rho_in[0][1];
    pi[1][4] = rho_in[3][1];
    
   //ROW_3
    pi[2][0] = rho_in[2][2];
    pi[2][1] = rho_in[0][2];
    pi[2][2] = rho_in[3][2];
    pi[2][3] = rho_in[1][2];
    pi[2][4] = rho_in[4][2];
    
   //ROW_4
    pi[3][0] = rho_in[3][3];
    pi[3][1] = rho_in[1][3];
    pi[3][2] = rho_in[4][3];
    pi[3][3] = rho_in[2][3];
    pi[3][4] = rho_in[0][3];
    
   //ROW_5
    pi[4][0] = rho_in[4][4];
    pi[4][1] = rho_in[2][4];
    pi[4][2] = rho_in[0][4];
    pi[4][3] = rho_in[3][4];
    pi[4][4] = rho_in[1][4];
 
  end
endmodule
