`timescale 1ns/1ps
module parse_tb;
  // Clock, reset, and control signals
  logic clk;
  logic rst;
  logic start;
  logic done;
  
  // Input and output arrays
  logic [9:0]  B [0:767];   // 768 words, 10-bit each
  logic [11:0] a [0:255];    // 256 words, 12-bit each

  // Instantiate the parse module
  parse uut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .B(B),
    .done(done),
    .a(a)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;
  
  // Testbench initial block
  initial begin
    $display("Starting simulation...");
    
    // Initialize reset and start signals
    rst   = 1;
    start = 0;
    #10;
    rst = 0;
    
    // Initialize input array B: B[k] = k (for k in 0..767)
    for (int k = 0; k < 768; k++) begin
      B[k] = k;
    end
    
    // Display the input array
    $display("Input B:");
    for (int k = 0; k < 768; k = k + 1) begin
      $write("%0d ", B[k]);
      if ((k+1) % 16 == 0) $write("\n");
    end
    
    // Start the parse module
    #10;
    start = 1;
    #10;
    start = 0;
    
    // Wait for the module to signal done.
    wait (done);
    #10;
    
    // Display the output array a
    $display("\nOutput array a:");
    for (int k = 0; k < 256; k++) begin
      $display("a[%0d] = %0d", k, a[k]);
    end
    
    $display("Simulation finished.");
    $finish;
  end

endmodule
