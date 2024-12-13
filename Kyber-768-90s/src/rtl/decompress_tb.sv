//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2024 16:36:29
// Design Name: 
// Module Name: decompress_tb
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


`timescale 1ns / 1ps

module decompress_tb;

  parameter Q = 3329;

  logic [15:0] x;  
  logic [15:0] d;  
  logic [15:0] result;  

  decompress_module dut (
    .x(x),
    .d(d),
    .result(result)
  );

  initial begin
    x = 1028;  
    d = 11;    

    #1; 

    $display("Input x: %0d, d: %0d | Decompressed result: %0d", x, d, result);

    $finish;
  end

endmodule