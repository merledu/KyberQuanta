`timescale 1ns / 1ps
module decompress_module (
    input logic [15:0] x,      
    input logic [15:0] d,      
    output logic [15:0] result  
);
    localparam int q = 3329;    

    always_comb begin
        logic [31:0] t;          
        t = 1 << (d - 1); 
        result = (q * x + t) >> d; 
    end
endmodule
