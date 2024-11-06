#include <verilated.h>
#include "Vbase_case_multiply.h" // Include the generated header for the module
#include <iostream>

int main(int argc, char **argv) {
    // Initialize Verilator
    Verilated::commandArgs(argc, argv);

    // Instantiate the module
    Vbase_case_multiply *tb = new Vbase_case_multiply;

    // Set input values
    tb->a0 = 245;
    tb->a1 = 1023;
    tb->b0 = 1864;
    tb->b1 = 1825;
    tb->gamma = 2285;

    // Evaluate the model (simulate)
    tb->eval();

    // Retrieve and print the outputs
    std::cout << "Output c0: " << tb->c0 << std::endl;
    std::cout << "Output c1: " << tb->c1 << std::endl;

    // Clean up and exit
    delete tb;
    return 0;
}
