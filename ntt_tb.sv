`timescale 1ns / 1ps

module ntt_tb;

  // Parameters
  parameter ARRAY_SIZE = 256;
  parameter TIMEOUT = 2000000; // 2ms timeout

  // DUT I/O signals
  logic clk;
  logic reset;
  logic start;
  logic signed [15:0] f [255:0];
  logic signed [15:0] f_hat [255:0];
  logic done;

  // Clock generation
  always #5 clk = ~clk; // 10ns clock period

  // DUT instance
  ntt dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .f(f),
    .f_hat(f_hat),
    .done(done)
  );

  // Timeout watchdog
  initial begin
    #TIMEOUT;
    $display("ERROR: Simulation timeout after %0d ns", TIMEOUT);
    $display("Simulation failed - check your design for infinite loops");
    $stop;
  end

  // Testbench logic
  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;
    start = 0;

    $display("\n=== NTT Testbench Started ===");
    $display("Initializing input array...");

    // Initialize the f array
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      f[i] = 0; // Initialize all to 0
    end

    // Set specific values for f as in the C++ testbench
    f[0] = 0;
    f[1] = 1;
    f[2] = 0;
    f[3] = -1;
    f[4] = 0;
    f[5] = 1;
    f[6] = 0;
    f[7] = -1;
    f[8] = 0;
    f[9] = 1;
    f[10] = 0;
    f[11] = -1;
    f[12] = 0;
    f[100] = -1;
    f[101] = 0;
    f[102] = 1;
    f[103] = 0;
    f[104] = -1;
    f[105] = 0;
    f[106] = 1;
    f[180] = -1;
    f[181] = 0;
    f[182] = 1;
    f[190] = 0;
    f[191] = -1;
    f[205] = 1;
    f[206] = 0;
    f[207] = -1;
    f[208] = 0;
    f[209] = 1;
    f[230] = 0;
    f[231] = -1;
    f[232] = 0;
    f[250] = -1;
    f[251] = 0;
    f[252] = 1;
    f[253] = 0;
    f[254] = 1;
    f[255] = -1;

    $display("\n=== Input Array Values ===");
    $display("Index \t Value");
    $display("------------------");
    for (int i = 0; i < ARRAY_SIZE; i++) begin
        $display("%0d \t %0d", i, f[i]);
    end

    // Release reset and start computation
    $display("\nStarting NTT computation...");
    #100;  // Longer reset period
    reset = 0;
    #100;  // Wait after reset
    start = 1;
    #20;   // Hold start for 2 clock cycles
    start = 0;

    // Wait for computation to complete
    @(posedge done);  // Wait for done to assert
    $display("\nNTT Computation completed at %0t ns", $time);
    #100;

    // Output the f_hat array values
    $display("\n=== NTT Computation Results ===");
    $display("Output array f_hat values (non-zero only):");
    $display("Index \t Value");
    $display("------------------");
    for (int i = 0; i < ARRAY_SIZE; i++) begin
      if (f_hat[i] != 0) begin  // Only show non-zero values for clarity
        $display("%0d \t %0d", i, f_hat[i]);
      end
    end

    $display("\n=== Simulation Complete at %0t ns ===", $time);
    // End simulation
    #1000;
    $finish;
  end

endmodule 