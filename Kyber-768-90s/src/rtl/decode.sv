module Decode #(parameter ELL = 8, parameter NUM_COEFFS = 256) (
    input logic [7:0] byte_array [31:0],  
    input logic [7:0] len,                
    output logic [ELL-1:0] coeffs [0:NUM_COEFFS-1] 
);

    logic bits [255:0]; 

    bytes_to_bits bytes_to_bits_inst (
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
                if (bit_index < 256) begin
                    coeffs[i] = coeffs[i] + ({{(ELL-1){1'b0}}, bits[bit_index]} << j); 
                end
            end
        end
    end
endmodule
