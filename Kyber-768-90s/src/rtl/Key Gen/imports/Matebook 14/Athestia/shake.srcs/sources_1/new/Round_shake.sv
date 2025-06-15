`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2024 03:34:27 PM
// Design Name: 
// Module Name: top
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


module Rnd (
    input logic [63:0] rc,
    input logic [63:0] A [0:4][0:4],
    output logic [63:0] X [0:4][0:4]
    );
    
    logic [63:0] T [0:4][0:4]; 
    logic [63:0] R [0:4][0:4];
    logic [63:0] P [0:4][0:4];
    logic [63:0] C [0:4][0:4];

 //SUBMODULE_1   
    Theta_shake u1_theta (    
        .A(A),          //input
        .theta(T)       //output
    );
    
//SUBMODULE_2         
    Rho_shake u1_rho(
        .theta_in(T),   //input
        .rho(R)         //output
    );
    
//SUBMODULE_3     
    Pi_shake u1_pi(
        .rho_in(R),     //input
        .pi(P)          //output
    );
    
//SUBMODULE_4     
    Chi_shake u1_chi(
        .B(P),          //input
        .chi(C)         //output
    );
    
//SUBMODULE_5     
    Iota_shake u1_iota(
        .rc(rc),        //input
        .chi(C),        //input
        .iota(X)        //output
    );
    
endmodule
