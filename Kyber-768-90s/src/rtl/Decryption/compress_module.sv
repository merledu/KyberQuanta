`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2025 10:14:54 PM
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
    output logic [15:0] result,
    output logic done         // Added 'done' output
);
    localparam int q = 3329;   

    always_comb begin
        logic [31:0] t;          
        logic [31:0] y;           

        t = 1 << d;  
        y = (t * x + (q >> 1)) / q; 
        result = y % t;

        done = 1'b1;   // Assert 'done' signal high immediately
    end
endmodule
