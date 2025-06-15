`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 12:20:32 PM
// Design Name: 
// Module Name: iota
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


module Iota_shake(
    input logic [63:0]rc,
    input logic [63:0]chi[0:4][0:4],
    output logic [63:0]iota[0:4][0:4]
    );
    
    always_comb begin
    
        //row1
        iota[0][0] = chi[0][0] ^ rc;
        iota[0][1] = chi[0][1];
        iota[0][2] = chi[0][2];
        iota[0][3] = chi[0][3];
        iota[0][4] = chi[0][4];
        
        //row2
        iota[1][0] = chi[1][0];
        iota[1][1] = chi[1][1];
        iota[1][2] = chi[1][2];
        iota[1][3] = chi[1][3];
        iota[1][4] = chi[1][4];
        
        //row3
        iota[2][0] = chi[2][0];
        iota[2][1] = chi[2][1];
        iota[2][2] = chi[2][2];
        iota[2][3] = chi[2][3];
        iota[2][4] = chi[2][4];
        
        //row4
        iota[3][0] = chi[3][0];
        iota[3][1] = chi[3][1];
        iota[3][2] = chi[3][2];
        iota[3][3] = chi[3][3];
        iota[3][4] = chi[3][4];
        
        //row5
        iota[4][0] = chi[4][0];
        iota[4][1] = chi[4][1];
        iota[4][2] = chi[4][2];
        iota[4][3] = chi[4][3];
        iota[4][4] = chi[4][4];
        
    end
endmodule
