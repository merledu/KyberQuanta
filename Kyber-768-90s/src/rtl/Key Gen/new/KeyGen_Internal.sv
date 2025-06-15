//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 13.04.2025 22:28:49
//// Design Name: 
//// Module Name: KeyGen_Internal
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////


module KeyGen_Internal(

 input  logic clk,
    input  logic rst,start,
    input  logic [255:0] d,  // randomness ? ?32
    input  logic [255:0] z,  // randomness ? ?32
    output logic [9472-1:0] ek, // ek ? ?384k+32 (Kyber768)
    output logic [19200-1:0] dk,
    output logic [255:0]  digest,
    output logic done_sha  // dk ? ?768k+96
);

    // Internal connections
    logic [9472-1:0] ek_PKE;
    logic [9472-1:0] ek_PKE_raw;
    logic [9216-1:0] dk_PKE;   // Combined output from K-PKE

//    logic [255:0]  digest;        // H(ekPKE)
    logic          done;
    

    // Instantiate K-PKE
    KeyGen k_pke_inst (
        .clk(clk),
        .rst(rst),
        .d(d),
        .ek_PKE(ek_PKE_raw),
        .dk_PKE(dk_PKE),
        .done(done)
    );

    // Instantiate SHA3-256 for H(ek)
  

    // Assemble ek and dk when hashing is done
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ek <= '0;
            dk <= '0;
        end else if (done && start)begin
        
//        $display("CHECL",rst);
            ek_PKE <= ek_PKE_raw; // Pad with 32 bits if needed
//            dk <= {z,digest,ek_PKE,dk_PKE};
        end 
    end

  Sha3_256 #()hash_inst (
        .clk(clk),
        .rst(rst),
        .start(done),
        .datain(ek), // You can choose how much of ekPKE to hash
        .digest(digest),
        .done(done_sha)
    );

always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            ek <= '0;
            dk <= '0;
        end else if (done_sha && done && start) begin
            ek <= ek_PKE;
            dk <= {z, digest, ek_PKE, dk_PKE};
        end
    end

endmodule
