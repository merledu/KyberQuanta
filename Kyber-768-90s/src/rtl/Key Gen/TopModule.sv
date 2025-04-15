`timescale 1ns / 1ps

module TopModule (
    input logic clk,   
    input logic rst,      
    input logic btn,  // Button to trigger addition
    output logic led  // LED output for indicating specific condition
);

    // Inputs to the adder
    logic [7:0] add1;
    logic [7:0] add2;
    logic [7:0] sum;

    // Instance of PolynomialAdder
    PolynomialAdder adder (
        .clock(clk),
        .reset(rst),
        .io_add1(add1),
        .io_add2(add2),
        .io_res(sum)
    );

    // Define behavior for add1 and add2
    initial begin
        add1 = 8'd15;  // Example value
        add2 = 8'd25;  // Example value
    end

    // LED control logic based on addition result
    always_ff @(posedge clk) begin
        if (rst) begin
            led <= 1'b0;  // Reset LED state
        end else if (btn) begin
            // Check if sum matches a specific value, here example 40
            if (sum == 8'd40) begin
                led <= 1'b1;  // Turn on LED if sum is 40
            end else begin
                led <= 1'b0;  // Turn off LED otherwise
            end
        end
    end

endmodule