module CBD(
    input logic [7:0] byte_array [31:0],  
    input logic [7:0] len,                 
    output logic signed f [255:0]   
);
    logic bit_array [255:0];              
    logic signed temp_f;           

    bytes_to_bits btb (
        .B(byte_array),
        .len(len),
        .b(bit_array)
    );

    
    always_comb begin
        for (int i = 0; i < 256; i++) begin
            f[i] = 0; 
        end

        for (int i = 0; i < 256; i++) begin
            temp_f = 0; 
            for (int j = 0; j < 2; j++) begin 
                logic a = bit_array[(2 * i * 2) + j];        
                logic b = bit_array[(2 * i * 2) + 2 + j];      
                temp_f += ($signed(a) - $signed(b)); 
            end
            f[i] = temp_f;
        end
    end
endmodule
