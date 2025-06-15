`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2024 03:58:30 PM
// Design Name: 
// Module Name: padding
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// // Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module padding#(
    parameter DATAIN = 2320,
    parameter RATE = 1088
)
(
    input logic check,
//    input logic [DATAIN - 1 : 0] datain,
    input logic [1087 : 0] datain,
    //input logic [0:DATAIN - 1] datain,    
    input logic [1599:0] state, //b=r+c
    output logic [63:0] A [0:4][0:4] 
);

logic [1087:0] temp1; //padded input
logic [1087:0] temp2; //xor
logic [1599:0] temp3; //concat
logic [703:0] B;

always_comb begin
        if (check==1'b0) begin
          temp1 = datain;
        end
        else begin
            if (DATAIN > RATE) begin
                B=datain;
                temp1 = { 1'b1,{(RATE - (DATAIN % RATE) - 4){1'b0}}, 3'b110, datain[(DATAIN%RATE - 1):0]};
            end
            else begin 
                temp1 = { 1'b1,{(RATE - DATAIN - 4){1'b0}}, 3'b110, datain[(DATAIN%RATE - 1):0]};
            end
        end

       temp2 = temp1 ^ state[1087:0];
       temp3 = {state[1599:1088],temp2};
       
   //COLUMN_1
       A[0][0] <= temp3[63:0];
       A[1][0] <= temp3[127:64];
       A[2][0] <= temp3[191:128];
       A[3][0] <= temp3[255:192];
       A[4][0] <= temp3[319:256];
      
      //COLUMN_2
        A[0][1] <= temp3[383:320];
        A[1][1] <= temp3[447:384];
        A[2][1] <= temp3[511:448];
        A[3][1] <= temp3[575:512];
        A[4][1] <= temp3[639:576];
     
      //COLUMN_3
         A[0][2] <= temp3[703:640];
         A[1][2] <= temp3[767:704];
         A[2][2] <= temp3[831:768];
         A[3][2] <= temp3[895:832];
         A[4][2] <= temp3[959:896];
   
      //COLUMN_4
       A[0][3] <= temp3[1023:960];
       A[1][3] <= temp3[1087:1024];
       A[2][3] <= temp3[1151:1088];
       A[3][3] <= temp3[1215:1152];
       A[4][3] <= temp3[1279:1216];
    
      //COLUMN_5
        A[0][4] <= temp3[1343:1280];
        A[1][4] <= temp3[1407:1344];
        A[2][4] <= temp3[1471:1408];
        A[3][4] <= temp3[1535:1472];
        A[4][4] <= temp3[1599:1536];

end
     
 endmodule