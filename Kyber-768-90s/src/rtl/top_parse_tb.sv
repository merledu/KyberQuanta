`timescale 1ns/1ps
module top_parse_tb;

    // Testbench signals
    logic clk;
    logic rst;
    logic btn;
    logic led;

    // Instantiate the top_parse module
    top_parse uut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Task to apply reset (assert reset for 20 ns)
    task reset_dut;
        begin
            rst = 1;
            #20;
            rst = 0;
        end
    endtask

    // Task to simulate a button press (btn high for 10 ns)
    task press_button;
        begin
            btn = 1;
            #10;
            btn = 0;
        end
    endtask

    // Testbench simulation flow
    initial begin
        rst = 0;
        btn = 0;
        $display("Starting simulation for top_parse with verification...");

        // Apply reset
        reset_dut();
        #50;

        // Trigger the parse operation with a button press (generates the start pulse)
        $display("Pressing button to initiate parse operation...");
        press_button();

        // Wait until the parse module signals done (with a timeout safeguard)
        fork
            begin
                wait (uut.parse_inst.done);
                $display("Parse module signaled done.");
            end
            begin
                #10000; // 10us timeout
                $display("Timeout: parse module did not signal done in time.");
                $finish;
            end
        join_any

        // Now, press the button again to sample the LED.
        #20;
        $display("Pressing button to check output verification...");
        press_button();

        #20;
        if (led)
            $display("[PASS] LED is high: Output matches expected.");
        else
            $display("[FAIL] LED is low: Output does not match expected.");

        $display("Simulation finished.");
        $finish;
    end

endmodule
