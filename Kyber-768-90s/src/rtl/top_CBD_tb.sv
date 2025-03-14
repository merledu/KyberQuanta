`timescale 1ns / 1ps

module top_CBD_tb;
    // Testbench signals
    logic clk;
    logic rst;
    logic btn;
    logic led;

    // Instantiate the DUT
    top_CBD dut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .led(led)
    );

    // Clock generator: 10 ns period (5 ns high, 5 ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Tasks for reset and button press
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

    // Main simulation process
    initial begin
        // Initialize signals
        rst = 0;
        btn = 0;
        
        // Apply reset
        $display("Applying reset...");
        reset_dut();
        
        // Allow time for initialization and processing
        #100;
        
        // Press button to check output
        $display("Pressing button to validate conversion...");
        press_button();
        
        // Check LED status
        #10;
        if (led) begin
            $display("[PASS] CBD output matches expected values. LED is ON.");
        end else begin
            $display("[FAIL] CBD output does not match expected values. LED is OFF.");
            
            // Optional: Print mismatched values for debugging
            for (int i = 0; i < 256; i++) begin
                if (dut.f[i] !== dut.expected_f[i]) begin
                    $display("Mismatch at index %0d: Expected %0d, Got %0d", 
                             i, dut.expected_f[i], dut.f[i]);
                end
            end
        end
        
        // End simulation
        #50;
        $display("Simulation completed");
        $finish;
    end
    
    // Additional monitor for verification
    initial begin
        $monitor("Time=%0t, Reset=%0b, Button=%0b, LED=%0b", 
                 $time, rst, btn, led);
    end
endmodule