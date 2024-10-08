module zeta_calculator #(parameter int ROOT_OF_UNITY = 17, parameter int Q = 3329, parameter int K = 7) (
    // input logic [K-1:0] idx,  
    // input logic clk,
    // input logic rst_n,         
    output logic [15:0] zetas [127:0]  
);
    logic [K-1:0] bit_rev_idx;         
    logic [31:0] root_of_unity_pow;   
    logic [15:0] temp_zeta;         

    function automatic logic [K-1:0] bit_reversal(input logic [K-1:0] value);
        logic [K-1:0] reversed;
        integer j;
        begin
            reversed = 0; 
            for (j = 0; j < K; j = j + 1) begin
                reversed[j] = value[K-1-j]; 
            end
            return reversed; 
        end
    endfunction
    always_comb begin
        for (int i = 0; i < 128; i = i + 1) begin
            zetas[i] = 16'b0; 
        end
        for (int i = 0; i < 128; i = i + 1) begin
            bit_rev_idx = bit_reversal(i[K-1:0]); 
            root_of_unity_pow = 1; 
            for (int j = 0; j < bit_rev_idx; j = j + 1) begin
                root_of_unity_pow = (root_of_unity_pow * ROOT_OF_UNITY) % Q; 
            end
            temp_zeta = root_of_unity_pow[15:0]; 
            zetas[i] = temp_zeta;
            // $display("z",zetas[i]);
        end
    end
endmodule
