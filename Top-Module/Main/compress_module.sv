`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 07:08:04 PM
// Design Name: 
// Module Name: compress_module
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



module compress_module (
    input logic [15:0] x,    
    input logic [15:0] d,      
    output logic [15:0] result    
);
    localparam int q = 3329;   

    always_comb begin
        logic [31:0] t;          
        logic [31:0] y;           
        t = 1 << d;  
        y = (t * x + (q >> 1)) / q; 
        result = y % t;  
    end
endmodule