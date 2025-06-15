`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2024 12:42:56 PM
// Design Name: 
// Module Name: fn_top
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


module fn_top_(
    input  logic clk,
    input  logic rst,
    input logic round_start,
    input  logic [63:0] A [0:4][0:4],
    output logic [1599:0] X,
    output logic round_done
    );
    
   logic [63:0] temp_out [0:4][0:4];
   logic [63:0] RC       [0:23];
   logic [63:0] temp_in  [0:4][0:4];
   logic r_temp;
   logic [63:0] rc_temp;
   
        always_comb begin
            RC[0]  = 64'h0000000000000001;     RC[1]  = 64'h0000000000008082;     RC[2]  = 64'h800000000000808a;
            RC[3]  = 64'h8000000080008000;     RC[4]  = 64'h000000000000808b;     RC[5]  = 64'h0000000080000001;
            RC[6]  = 64'h8000000080008081;     RC[7]  = 64'h8000000000008009;     RC[8]  = 64'h000000000000008a;
            RC[9]  = 64'h0000000000000088;     RC[10] = 64'h0000000080008009;     RC[11] = 64'h000000008000000a;
            RC[12] = 64'h000000008000808b;     RC[13] = 64'h800000000000008b;     RC[14] = 64'h8000000000008089;
            RC[15] = 64'h8000000000008003;     RC[16] = 64'h8000000000008002;     RC[17] = 64'h8000000000000080;
            RC[18] = 64'h000000000000800a;     RC[19] = 64'h800000008000000a;     RC[20] = 64'h8000000080008081;
            RC[21] = 64'h8000000000008080;     RC[22] = 64'h0000000080000001;     RC[23] = 64'h8000000080008008;     
        end

    logic [4:0] count;

    // 0: IDLE
    // 1-24: 1-24 Rounds
    // 25: DONE
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            r_temp <= 0;
            rc_temp <= 64'h0;
            temp_in <= '{default: 64'b0};
        end
        else begin
            // rc_temp
            if (count >= 0 && count < 24) begin
                rc_temp <= RC[count];
            end
            // r_temp
            if (count == 24) begin
                r_temp <= 1;
            end
            else begin
                r_temp <= 0;
            end
            // temp_in and temp_out
            if (count == 0) begin
                temp_in <= A;
            end
            else if (count >= 1 && count < 24) begin
                temp_in <= temp_out;
            end
            // count
            if (round_start) begin
                if (count == 25) begin
                    count <= 0;
                end
                else begin
                    count <= count + 1;
                end
            end
            else begin
            count <= count;
            end
        end
    end

       fn u_fn_78 (
            .rc(rc_temp),
            .A(temp_in),
            .X(temp_out)
       );
       
       //COLUMN_1
            assign X[63:0]    = temp_out[0][0];
            assign X[127:64]  = temp_out[1][0];
            assign X[191:128] = temp_out[2][0];
            assign X[255:192] = temp_out[3][0];
            assign X[319:256] = temp_out[4][0];
                              
       //COLUMN_2
            assign X[383:320] = temp_out[0][1];
            assign X[447:384] = temp_out[1][1];
            assign X[511:448] = temp_out[2][1];
            assign X[575:512] = temp_out[3][1];
            assign X[639:576] = temp_out[4][1];
                             
       //COLUMN_3
            assign X[703:640] = temp_out[0][2];
            assign X[767:704] = temp_out[1][2];
            assign X[831:768] = temp_out[2][2];
            assign X[895:832] = temp_out[3][2];
            assign X[959:896] = temp_out[4][2];
                           
       //COLUMN_4
            assign X[1023:960]  = temp_out[0][3];
            assign X[1087:1024] = temp_out[1][3];
            assign X[1151:1088] = temp_out[2][3];
            assign X[1215:1152] = temp_out[3][3];
            assign X[1279:1216] = temp_out[4][3];
                            
       //COLUMN_5
            assign X[1343:1280] = temp_out[0][4];
            assign X[1407:1344] = temp_out[1][4];
            assign X[1471:1408] = temp_out[2][4];
            assign X[1535:1472] = temp_out[3][4];
            assign X[1599:1536] = temp_out[4][4];
            
            assign round_done = r_temp;

endmodule