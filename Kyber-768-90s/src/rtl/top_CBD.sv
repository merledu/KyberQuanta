`timescale 1ns / 1ps

module top_CBD (
    input logic clk,   
    input logic rst,      
    input logic btn,      
    output logic led     
);

    // Local parameters
    localparam BYTE_COUNT = 256;
    localparam BIT_COUNT = BYTE_COUNT * 8;

    // Input and output signals for CBD module
    logic [7:0] byte_array [0:BYTE_COUNT-1];
    logic [$clog2(BYTE_COUNT):0] len;
    logic signed [1:0] f [0:BYTE_COUNT-1];
    
    // Flag to check if output matches expected values
    logic output_match;

    // Predefined expected output array
    logic signed [1:0] expected_f [0:BYTE_COUNT-1];

    // Initialize byte array with test values
    initial begin
        byte_array = '{
            239, 146, 18, 231, 103, 64, 94, 210, 60, 7, 156, 171, 109, 127, 244, 200,
            171, 204, 57, 113, 182, 148, 171, 188, 54, 3, 187, 198, 223, 204, 80, 61,
            110, 239, 24, 203, 12, 174, 150, 53, 10, 135, 41, 201, 250, 104, 126, 171,
            119, 45, 144, 244, 215, 196, 141, 129, 154, 244, 218, 203, 122, 64, 250, 12,
            90, 192, 118, 247, 109, 206, 153, 77, 74, 165, 18, 140, 60, 78, 123, 130,
            236, 110, 12, 12, 149, 224, 90, 49, 125, 33, 211, 238, 205, 127, 104, 61,
            51, 252, 101, 200, 250, 105, 18, 74, 242, 146, 102, 90, 212, 231, 245, 99,
            184, 184, 131, 163, 13, 157, 129, 211, 5, 112, 57, 193, 156, 31, 133, 183,
            185, 49, 231, 225, 222, 245, 1, 197, 92, 148, 230, 198, 93, 65, 185, 209,
            48, 158, 135, 37, 150, 111, 247, 195, 65, 58, 17, 181, 241, 145, 225, 127,
            214, 158, 9, 44, 112, 92, 232, 162, 104, 69, 243, 190, 224, 192, 181, 0,
            238, 78, 79, 89, 251, 59, 235, 25, 140, 43, 148, 99, 172, 17, 35, 21,
            40, 88, 115, 150, 227, 98, 143, 120, 243, 180, 62, 73, 95, 217, 201, 56,
            152, 84, 37, 155, 29, 164, 203, 205, 226, 17, 68, 188, 187, 209, 196, 176,
            193, 122, 51, 190, 141, 59, 12, 28, 150, 217, 110, 171, 93, 4, 192, 223,
            91, 187, 195, 185, 49, 124, 198, 219, 252, 70, 155, 96, 131, 210, 25, 43
        };
        
        // Initialize expected output f array
        expected_f = '{
            2'sd0, -2'sd1, 2'sd0, 2'sd1, 2'sd0, 2'sd1, 2'sd0, -2'sd1,
            2'sd0, -2'sd1, 2'sd0, -2'sd1, -2'sd1, 2'sd0, 2'sd0, 2'sd0,
            -2'sd1, 2'sd1, 2'sd0, 2'sd0, -2'sd1, 2'sd1, 2'sd1, 2'sd0,
            2'sd0, -2'sd1, 2'sd0, 2'sd0, -2'sd1, 2'sd0, 2'sd0, -2'sd1,
            2'sd1, 2'sd0, -2'sd1, -2'sd1, 2'sd1, 2'sd1, 2'sd1, 2'sd0,
            -2'sd1, 2'sd1, -2'sd1, 2'sd1, 2'sd1, 2'sd0, -2'sd1, 2'sd1,
            -2'sd1, 2'sd1, 2'sd1, 2'sd0, 2'sd1, 2'sd1, -2'sd1, -2'sd1,
            2'sd0, 2'sd0, -2'sd1, -2'sd1, 2'sd0, 2'sd0, 2'sd0, 2'sd1,
            -2'sd1, -2'sd1, 2'sd0, -2'sd1, 2'sd0, 2'sd1, 2'sd1, -2'sd1,
            -2'sd1, 2'sd0, -2'sd1, 2'sd0, -2'sd1, 2'sd1, 2'sd0, 2'sd1,
            2'sd0, 2'sd0, 2'sd0, 2'sd0, 2'sd1, 2'sd0, 2'sd1, -2'sd1,
            2'sd0, 2'sd0, 2'sd0, -2'sd1, -2'sd1, 2'sd0, 2'sd1, 2'sd0,
            2'sd0, 2'sd0, 2'sd0, 2'sd0, 2'sd0, 2'sd1, -2'sd1, 2'sd0,
            2'sd0, 2'sd0, -2'sd1, -2'sd1, 2'sd0, 2'sd0, 2'sd1, 2'sd0,
            2'sd0, 2'sd1, -2'sd1, 2'sd0, 2'sd0, 2'sd0, 2'sd1, -2'sd1,
            2'sd0, 2'sd0, 2'sd0, -2'sd1, 2'sd0, 2'sd0, -2'sd1, 2'sd0,
            2'sd0, 2'sd0, 2'sd0, -2'sd1, -2'sd1, 2'sd0, 2'sd0, 2'sd0,
            2'sd0, -2'sd1, -2'sd1, -2'sd1, 2'sd1, 2'sd1, 2'sd0, -2'sd1,
            2'sd0, -2'sd1, 2'sd0, 2'sd0, 2'sd0, 2'sd1, -2'sd1, 2'sd0,
            -2'sd1, 2'sd1, -2'sd1, -2'sd1, 2'sd1, 2'sd0, 2'sd0, 2'sd0,
            -2'sd1, -2'sd1, -2'sd1, -2'sd1, -2'sd1, 2'sd0, -2'sd1, 2'sd0,
            2'sd0, 2'sd1, 2'sd0, -2'sd1, 2'sd0, 2'sd0, 2'sd1, 2'sd1,
            2'sd0, 2'sd0, 2'sd1, 2'sd0, 2'sd1, 2'sd0, -2'sd1, -2'sd1,
            2'sd0, -2'sd1, 2'sd0, 2'sd0, 2'sd0, -2'sd1, 2'sd0, 2'sd1,
            2'sd1, 2'sd1, -2'sd1, 2'sd0, 2'sd0, -2'sd1, 2'sd0, -2'sd1,
            2'sd0, 2'sd0, 2'sd1, -2'sd1, 2'sd0, 2'sd1, 2'sd0, -2'sd1,
            2'sd0, 2'sd0, 2'sd0, 2'sd1, -2'sd1, -2'sd1, 2'sd0, 2'sd0,
            -2'sd1, 2'sd0, 2'sd0, -2'sd1, 2'sd0, 2'sd0, 2'sd1, -2'sd1,
            2'sd0, 2'sd1, 2'sd0, 2'sd1, 2'sd1, 2'sd0, 2'sd1, 2'sd0,
            2'sd0, 2'sd0, 2'sd0, 2'sd1, 2'sd1, 2'sd0, 2'sd1, 2'sd0,
            2'sd0, 2'sd0, 2'sd0, 2'sd0, 2'sd1, 2'sd1, 2'sd1, -2'sd1,
            -2'sd1, 2'sd1, 2'sd0, 2'sd1, 2'sd0, 2'sd0, 2'sd0, 2'sd1
        };
    end

    // Set length for CBD module
    assign len = BYTE_COUNT;

    // Instantiate the CBD module
    CBD cbd_inst (
        .clk(clk),
        .reset(rst),
        .byte_array(byte_array),
        .len(len),
        .f(f)
    );

    // Check if output matches expected values
    integer i;
    always_comb begin
        output_match = 1'b1;
        for (i = 0; i < BYTE_COUNT; i = i + 1) begin
            if (f[i] !== expected_f[i]) begin
                output_match = 1'b0;
            end
        end
    end

    // Control LED based on button press and output match
    always_ff @(posedge clk) begin
        if (rst)
            led <= 1'b0;
        else if (btn)
            led <= output_match;
    end


endmodule