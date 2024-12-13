//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.12.2024 16:10:26
// Design Name: 
// Module Name: compress_tb
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

module compress_tb;

  parameter int Q = 3329; 

  logic [15:0] x;
  logic [15:0] d;
  logic [15:0] result;

  compress_module dut (
    .x(x),
    .d(d),
    .result(result)
  );

  initial begin
    x = 3331; 
    d = 11;   

    #1; 

    for (int cycle = 0; cycle < 10; cycle++) begin
      #1; 
      if (cycle == 9) begin
        $display("Time: %0t | Compressed value: %0d", $time, result);
      end
    end

    $finish;
  end

endmodule