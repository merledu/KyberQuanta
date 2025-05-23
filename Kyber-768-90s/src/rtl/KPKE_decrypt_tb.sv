`timescale 1ns / 1ps

module KPKE_decrypt_tb;

    localparam DK_BYTES  = 1152;
    localparam C_BYTES   = 1088;
    localparam MSG_BYTES = 32;

    logic clk;
    logic rst;
    logic start;
    logic [7:0] dk_PKE [0:DK_BYTES-1];
    logic [7:0] c      [0:C_BYTES-1];
    logic done;
    logic [7:0] m      [0:MSG_BYTES-1];

    K_PKE_Decrypt #(
        .DK_BYTES(DK_BYTES),
        .C_BYTES(C_BYTES),
        .MSG_BYTES(MSG_BYTES)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .dk_PKE(dk_PKE),
        .c(c),
        .done(done),
        .m(m)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    reg [9215:0] dk_PKE_bits;
    reg [8703:0] c_bits;

    initial begin
        integer i;
        rst = 1;
        start = 0;

        $display("== Initializing Testbench ==");
        #20;
        rst = 0;
        $display("[Cycle %0t] Deasserted reset", $time);

        // Load byte arrays
        for (i = 0; i < DK_BYTES; i = i + 1)
            dk_PKE[i] = dk_PKE_bits[(DK_BYTES - 1 - i)*8 +: 8];
        for (i = 0; i < C_BYTES; i = i + 1)
            c[i] = c_bits[(C_BYTES - 1 - i)*8 +: 8];

        $display("[Cycle %0t] Loaded dk_PKE and c values", $time);

        #10;
        start = 1;
        $display("[Cycle %0t] Asserted start signal", $time);

        #10;
        start = 0;
        $display("[Cycle %0t] Deasserted start signal", $time);

        // Monitor done signal and output
        wait (done == 1);
        $display("[Cycle %0t] Done signal asserted", $time);

        $display("== Decrypted Message ==");
        for (i = 0; i < MSG_BYTES; i = i + 1) begin
            $display("m[%0d] = %02x", i, m[i]);
        end

        $display("== Testbench Complete ==");
        #20;
        $finish;
    end

endmodule
