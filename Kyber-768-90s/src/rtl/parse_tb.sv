`timescale 1ns / 1ps

module parse_tb;

    logic clk;
    logic rst;
    logic [15:0] B[767:0];
    logic [15:0] a[255:0];

    // Instantiate the parse module
    parse #(.Q(3329)) DUT (
        .clk(clk),
        .rst(rst),
        .B(B),
        .a(a)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // Clock with a period of 10ns
    end
    
    // Initialize and run the test
    initial begin
        rst = 1;
        #10 rst = 0;  // Apply reset for 10ns (previously was 20ns, but corrected to match comment)
        $display("Reset released at %t, clk=%b, rst=%b", $time, clk, rst);
        #10;
        $display("Post-reset check at %t, clk=%b, rst=%b", $time, clk, rst);

        // Initialize B with the same values as in Python
        for (int i = 0; i < 768; i++) begin
            B[i] = i % 3329;
            $display("B[%0d] initialized to %0d at time %t", i, B[i], $time);
        end
    
        // Extend simulation time to ensure it covers the required number of iterations
        #500000; // Increased wait time for extended simulation

        // Print the output after processing is complete
        for (int i = 0; i < 256; i++) begin
            $display("a[%0d] = %0d at time %t", i, a[i], $time);
        end
    
        $finish; // End the simulation
    end
endmodule
