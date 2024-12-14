module decode #(parameter ELL = 8, parameter NUM_COEFFS = 256) (
    input logic [7:0] byte_array [31:0],  
    input logic [7:0] len,                
    output logic [ELL-1:0] coeffs [0:NUM_COEFFS-1] 
);

    logic [255:0] bits; 

    // Instantiate bytes_to_bits
    bytes_to_bits #(
        .BYTE_COUNT(32),                 // Match the size of byte_array
        .BIT_COUNT(256)                  // Total bits (32 bytes * 8 bits)
    ) bytes_to_bits_inst (
        .B(byte_array),                  // Connect byte_array as input
        .len(len),                       // Length of input array
        .b(bits)                         // Connect packed bits array as output
    );

    integer i, j;
    always_comb begin
        for (i = 0; i < NUM_COEFFS; i = i + 1) begin
            coeffs[i] = 0;
            for (j = 0; j < ELL; j = j + 1) begin
                int bit_index = i * ELL + j;
                if (bit_index < 256) begin
                    coeffs[i] = coeffs[i] + ({{(ELL-1){1'b0}}, bits[bit_index]} << j); 
                end
            end
        end
    end
endmodule