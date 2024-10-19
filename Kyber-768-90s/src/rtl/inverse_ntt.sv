module inverse_ntt #(parameter N = 256, parameter Q = 3329, parameter F = 3303) (
    input  logic signed [31:0] f [255:0], 
    output logic signed [31:0] f_hat [255:0] 
);

    logic signed [15:0] zetas [127:0]; 
    integer signed i, j, length, start;  
    logic signed [15:0] zeta;
    logic signed [15:0] temp; 
    zeta_calculator #(.ROOT_OF_UNITY(17), .Q(3329), .K(7)) zeta_inst (
        .zetas(zetas)
    );

    always_comb begin
        for (i = 0; i < N; i = i + 1) begin
            f_hat[i] = f[i];
        end

        i = 127;  
        length = 2;
        while (length <= 128) begin 
            start = 0;
            while (start < N) begin 
                zeta = zetas[i];
                i = i - 1;
                for (j = start; j < start + length; j = j + 1) begin
                    temp = f_hat[j];
                    f_hat[j] = (temp + f_hat[j + length]) % Q ;
                    f_hat[j + length] = (f_hat[j + length] - temp) % Q ;
                    f_hat[j + length] = (zeta * f_hat[j + length]) % Q;
                    if (f_hat[j + length] < 0)
                        f_hat[j + length] = f_hat[j + length] + Q;
                end
                start = start + 2 * length;
                
            end
            length = length << 1;
            
        end
        for (j = 0; j < N; j = j + 1) begin
            f_hat[j] = (f_hat[j] * F) % Q;
            if (f_hat[j] == Q - 1) 
                f_hat[j] = -1;
        end
    end
endmodule
