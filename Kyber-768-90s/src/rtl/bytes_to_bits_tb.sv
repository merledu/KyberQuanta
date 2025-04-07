`timescale 1ns / 1ps

module tb_bytes_to_bits;

    localparam BYTE_COUNT = 128; 
    localparam BIT_COUNT = BYTE_COUNT * 8;

    logic [7:0] B [BYTE_COUNT-1:0]; 
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
        len = 128; 

        for (i = 0; i < BYTE_COUNT; i++) begin
            test_data[i] = (i < 256) ? i : 8'h00; 
        end

//        for (i = 0; i < BYTE_COUNT; i++) begin
//            B[i] = test_data[i];
//        end
B = '{ 185, 49, 231, 225, 222, 245, 1, 197, 92, 148, 230, 198, 93, 65, 185, 209,
           48, 158, 135, 37, 150, 111, 247, 195, 65, 58, 17, 181, 241, 145, 225, 127,
           214, 158, 9, 44, 112, 92, 232, 162, 104, 69, 243, 190, 224, 192, 181, 0,
           238, 78, 79, 89, 251, 59, 235, 25, 140, 43, 148, 99, 172, 17, 35, 21,
           40, 88, 115, 150, 227, 98, 143, 120, 243, 180, 62, 73, 95, 217, 201, 56,
           152, 84, 37, 155, 29, 164, 203, 205, 226, 17, 68, 188, 187, 209, 196, 176,
           193, 122, 51, 190, 141, 59, 12, 28, 150, 217, 110, 171, 93, 4, 192, 223,
           91, 187, 195, 185, 49, 124, 198, 219, 252, 70, 155, 96, 131, 210, 25, 43};
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
//        $display("Validating output...");
//        for (i = 0; i < len; i++) begin
//            if (b[i*8 +: 8] !== test_data[i]) begin
//                $fatal("Mismatch at byte %0d: Expected %0h, Got %0h", i, test_data[i], b[i*8 +: 8]);
//            end
//        end
//        $display("Test Case 1 Passed!");

        $finish;
    end

endmodule
