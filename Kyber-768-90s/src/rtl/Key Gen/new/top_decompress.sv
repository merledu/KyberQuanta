`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.12.2024 22:14:15
// Design Name: 
// Module Name: top_decompress
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

module top_decompress (
    input logic clk,         
    input logic rst,         
    input logic btn,         
    output logic led        
);

   
    logic [15:0] x;         
    logic [15:0] d;          
    logic [15:0] result;     
    logic [15:0] expected_result; 
    
    assign x = 16'd1028;     
    assign d = 16'd11;      
    assign expected_result = 16'd1671; 

    
    decompress_module decompress_inst (
        .x(x),
        .d(d),
        .result(result)
    );

    
    always_comb begin
        if (rst) begin
       
            led = 16'b0;
        end else if (btn) begin
            
            if (result == expected_result) begin
                led = 1'b1; 
            end else begin
                led = 1'b0; 
            end
        end else begin
            
            led = 16'b0;
        end
    end

endmodule
