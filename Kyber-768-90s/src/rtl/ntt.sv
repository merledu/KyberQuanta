module ntt #(parameter N = 256, parameter Q = 3329) (
    input  logic clk,
    input  logic rst_n,
    output logic [15:0] f_hat [N-1:0]
);

    logic [15:0] f [N-1:0];      
    logic [15:0] zetas [127:0];   
    integer i, j, length, start;   
    logic [15:0] zeta, temp;       
    logic [K-1:0] idx; 

    zeta_calculator #(.ROOT_OF_UNITY(17), .Q(3329), .K(7)) zeta_inst (
        .idx(idx),
        .clk(clk),
        .rst_n(rst_n),
        .zetas(zetas)
    );

    initial begin
        f[0] = 122;  f[1] = 456;  f[2] = 789;  f[3] = 1024; 
        f[255] = 3500;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 1;
            length <= 128;
        end else begin
            if (length >= 2) begin
                start = 0;
                while (start < N) begin
                    zeta = zetas[i - 1]; 
                    for (j = start; j < start + length; j = j + 1) begin
                        temp = (zeta * f[j + length]) % Q;      
                        f_hat[j + length] = (f[j] - temp + Q) % Q; 
                        f_hat[j] = (f[j] + temp) % Q;           
                    end
                    start = start + 2 * length;
                    i = i + 1;
                end
                length = length / 2;
            end
        end
    end
endmodule
