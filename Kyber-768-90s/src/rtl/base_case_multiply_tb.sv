`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2024 13:31:10
// Design Name: 
// Module Name: base_case_multiply_tb
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

module base_case_multiply_tb;

  logic [15:0] a0;
  logic [15:0] a1;
  logic [15:0] b0;
  logic [15:0] b1;
  logic [15:0] gamma;
  logic [15:0] c0;
  logic [15:0] c1;

  base_case_multiply dut (
    .a0(a0),
    .a1(a1),
    .b0(b0),
    .b1(b1),
    .gamma(gamma),
    .c0(c0),
    .c1(c1)
  );

  initial begin
    a0 = 16'd245;
    a1 = 16'd1023;
    b0 = 16'd1864;
    b1 = 16'd1825;
    gamma = 16'd2285;
    #1; 

    $display("Output c0: %0d", c0);
    $display("Output c1: %0d", c1);

    $finish;
  end

endmodule