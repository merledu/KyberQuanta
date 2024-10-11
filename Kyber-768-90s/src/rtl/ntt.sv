
module ntt #(parameter N = 256, parameter Q = 3329) (
    input  logic signed [15:0] f [255:0],  
    output logic signed [15:0] f_hat [255:0]
);
    logic signed [15:0] zetas [127:0];   
    integer i, j, length, start, m;   
    logic signed [15:0] zeta, temp;       

    zeta_calculator #(.ROOT_OF_UNITY(17), .Q(3329), .K(7)) zeta_inst (
        .zetas(zetas)
    );
    always_comb begin
        i = 1;
        length = 128;
        for (int k = 0; k < N; k++) begin
            f_hat[k] = f[k];
        end
        while (length >= 2) begin 
            start = 0;
            while (start < N) begin 
                zeta = zetas[i];
                i = i + 1;
                for (j = start; j < start + length; j = j + 1) begin
                    temp = (zeta * f_hat[j + length]) % Q;
                    if (temp < 0) temp = temp + Q;
                    f_hat[j + length] = (f_hat[j] - temp) % Q;
                    if (f_hat[j + length] < 0) f_hat[j + length] = f_hat[j + length] + Q;
                    f_hat[j] = (f_hat[j] + temp) % Q;
                    if (f_hat[j] < 0) f_hat[j] = f_hat[j] + Q;
                end
                start = start + 2 * length;;
            end
            length = length >> 1;
        end
        for (m = 0; m < 256; m = m + 1) begin 
            f_hat[m] = f_hat[m] % Q;
            if (f_hat[m] < 0) begin
                f_hat[m] = f_hat[m] + Q;
            end
        end
    end
endmodule
