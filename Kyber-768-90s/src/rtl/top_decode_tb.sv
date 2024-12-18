`timescale 1ns / 1ps

module top_decode_tb;

    logic clk;
    logic rst;
    logic btn;
    logic led;

    localparam CLK_PERIOD = 10;
    always #(CLK_PERIOD / 2) clk = ~clk;

    top_decode dut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    initial begin
        clk = 0;
        rst = 1;
        btn = 0;

        #20;
        rst = 0;

        #20;

        btn = 1;
        #20;

        $display("Comparing computed and expected coefficients:");
        for (int i = 0; i < dut.NUM_COEFFS; i++) begin
            $display("Index %0d: Computed = %0d, Expected = %0d", i, dut.coeffs[i], dut.expected_coeffs[i]);
        end

        if (led) begin
            $display("Test Passed: LED is ON, coefficients match expected values.");
        end else begin
            $display("Test Failed: LED is OFF, coefficients do not match.");
        end

        btn = 0;
        #10;
        $finish;
    end

    initial begin
        $monitor("Time = %0t | clk = %b | rst = %b | btn = %b | led = %b",
                 $time, clk, rst, btn, led);
    end

endmodule
