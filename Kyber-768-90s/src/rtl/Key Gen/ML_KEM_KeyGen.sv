module ML_KEM_KeyGenTop (
    input  logic clk,
    input  logic rst,
//    input  logic start,                   // Trigger to start key generation
    input  logic [255:0] d,              // 32-byte randomness
    input  logic [255:0] z,              // 32-byte randomness
    output logic [9472-1:0] ek,          // Encapsulation key
    output logic [19200-1:0] dk,         // Decapsulation key
    output logic [255:0] digest,         // SHA digest
    output logic done,                   // Done signal
    output logic error                   // Error if d or z is null
);

    logic done_sha_internal;
    logic start;

    // Error if randomness is all 0s
    assign error = (d == 256'b0) || (z == 256'b0);

    // Simple control logic
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            start <= 0;
            done<=0;
        end else if (!error) begin
            start <= 1;
        end else if (start && !error && done_sha_internal)begin
        done <= 1;
         end
        else begin
            start <= 0;
            done <= 0;
        end
    end

    // Internal Key Generation Module
    KeyGen_Internal u_keygen_internal (
        .clk(clk),
        .rst(rst),
        .start(start),
        .d(d),
        .z(z),
        .ek(ek),
        .dk(dk),
        .digest(digest),
        .done_sha(done_sha_internal)
    );

endmodule
