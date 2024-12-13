module Decode #(parameter ELL = 8, parameter NUM_COEFFS = 256, parameter BYTE_COUNT = 32) (
    input logic [7:0] byte_array [0:BYTE_COUNT-1],  // Input byte array
    input logic [$clog2(BYTE_COUNT):0] len,        // Length of valid bytes
    output logic [ELL-1:0] coeffs [0:NUM_COEFFS-1] // Output coefficients
);

    // Adjust bits array size to match BYTE_COUNT * 8
    logic [BYTE_COUNT*8-1:0] bits;

    // Instantiate bytes_to_bits module
    bytes_to_bits #(
        .BYTE_COUNT(BYTE_COUNT), 
        .BIT_COUNT(BYTE_COUNT * 8)
    ) bytes_to_bits_inst (
        .B(byte_array),
        .len(len),
        .b(bits)
    );

    integer i, j;
    always_comb begin
        for (i = 0; i < NUM_COEFFS; i = i + 1) begin
            coeffs[i] = 0;
            for (j = 0; j < ELL; j = j + 1) begin
                int bit_index = i * ELL + j;
                if (bit_index < BYTE_COUNT * 8) begin
                    coeffs[i] = coeffs[i] + ({{(ELL-1){1'b0}}, bits[bit_index]} << j); 
                end
            end
        end
    end
endmodule
