`timescale 1ns / 1ps

module top_bytes_to_bits_tb;

    localparam BYTE_COUNT = 256;
    localparam BIT_COUNT = BYTE_COUNT * 8;

    logic clk;
    logic rst;
    logic btn;
    logic led;

    top_bytes_to_bits dut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    task reset_dut;
        begin
            rst = 1;
            #20;
            rst = 0;
        end
    endtask

    task press_button;
        begin
            btn = 1;
            #20;
            btn = 0;
        end
    endtask

    initial begin
        rst = 0;
        btn = 0;

        $display("Applying reset...");
        reset_dut();

        #50;

        $display("Pressing button to validate conversion...");
        press_button();

        #10;
        if (led) begin
            $display("[PASS] Conversion valid. LED is ON.");
        end else begin
            $display("[FAIL] Conversion invalid. LED is OFF.");
        end

        $stop;
    end

endmodule
