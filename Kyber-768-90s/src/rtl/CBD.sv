`timescale 1ns / 1ps
module CBD #(
    parameter int eta = 2 // Default size of the input array
)(
    input logic [7:0] byte_array [(64 * eta) - 1:0], // Input byte array
    input logic [$clog2(64 * eta):0] len,           // Length of the input byte array
    output logic signed [255:0] f                  // Output signed array of size 256
);

    // Intermediate signals
    logic [512 * eta - 1:0] bit_array;  // Bit array converted from byte array
    logic signed temp_f;         // Temporary signed logic for calculations

    // Instantiate the bytes_to_bits module
    bytes_to_bits #(
        .BYTE_COUNT(64 * eta),
        .BIT_COUNT(512 * eta)
    ) btb (
        .B(byte_array),
        .len(len),
        .b(bit_array)
    );

    // Calculate the CBD transformation
    always_comb begin
        for (int i = 0; i < 256; i++) begin
            f[i] = 0; // Explicitly initialize each element to 0
        end

        for (int i = 0; i < 256; i++) begin
            temp_f = 0; // Reset temporary value for each output index
            for (int j = 0; j < 2; j++) begin
                logic a = bit_array[(2 * i * 2) + j];     // Extract bits from bit_array
                logic b = bit_array[(2 * i * 2) + 2 + j]; // Extract corresponding bits
                $display("a", a);
                $display("b", b);
                temp_f += (a - b);      // Calculate unsigned difference
                $display("temp_f", temp_f);
            end
            f[i] = temp_f; // Assign to the output
            $display("f[i]", f[i]);
        end
    end

endmodule