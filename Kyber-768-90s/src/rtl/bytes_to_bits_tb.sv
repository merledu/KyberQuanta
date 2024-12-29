`timescale 1ns / 1ps

module tb_bytes_to_bits;

    localparam BYTE_COUNT = 256; 
    localparam BIT_COUNT = BYTE_COUNT * 8;

    logic [7:0] B [0:BYTE_COUNT-1]; 
    logic [$clog2(BYTE_COUNT):0] len; 
    logic [BIT_COUNT-1:0] b; 

    bytes_to_bits #(
        .BYTE_COUNT(BYTE_COUNT),
        .BIT_COUNT(BIT_COUNT)
    ) uut (
        .B(B),
        .len(len),
        .b(b)
    );
    logic [7:0] test_data [0:BYTE_COUNT-1]; 
    integer i; 

    initial begin
        $display("Starting Test Case 1...");
        len = 256; 

        for (i = 0; i < BYTE_COUNT; i++) begin
            test_data[i] = (i < 256) ? i : 8'h00; 
        end

        for (i = 0; i < BYTE_COUNT; i++) begin
            B[i] = test_data[i];
        end

        $display("Input Byte Array:");
        for (i = 0; i < len; i++) begin
            $write("B[%0d] = %h ", i, B[i]);
            if (i % 8 == 7) $display(""); 
        end
        $display("");

        #1; 
        $display("Output Bit Array Length: %0d bits", len * 8);

        $display("Output Bit Array:");
        for (i = 0; i < len * 8; i++) begin
            $write("%b", b[i]);
            if (i % 8 == 7) $write(" "); 
            if (i % 64 == 63) $display(""); 
        end
        $display("");
        $display("Validating output...");
        for (i = 0; i < len; i++) begin
            if (b[i*8 +: 8] !== test_data[i]) begin
                $fatal("Mismatch at byte %0d: Expected %0h, Got %0h", i, test_data[i], b[i*8 +: 8]);
            end
        end
        $display("Test Case 1 Passed!");

        $finish;
    end

endmodule
