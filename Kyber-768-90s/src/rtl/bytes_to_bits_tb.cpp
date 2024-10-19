#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbytes_to_bits.h"  // Include the generated header for your module

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate the DUT (Device Under Test)
    Vbytes_to_bits *dut = new Vbytes_to_bits;

    // Enable trace dumping (if needed)
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("bytes_to_bits.vcd");

    // Initialize input array B with example byte values
    uint8_t B[32] = {
        0xFF, 0x00, 0xEF, 0x01, 0xFF, 0xFF, 0x67, 0x89,
        0x00, 0xFF, 0x55, 0xAA, 0x7E, 0x5A, 0x3C, 0x1E,
        0xFF, 0x0F, 0x33, 0x77, 0x11, 0x22, 0x44, 0x88,
        0x99, 0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x77, 0xFF
    };

    // Assign values to DUT input (B)
    for (int i = 0; i < 32; i++) {
        dut->B[i] = B[i];  // Copy byte values into the DUT's B array
    }

    // Set the length of the input array (len)
    dut->len = 32;  // Example length, corresponds to the input data size

    // Simulate and evaluate the DUT for a few cycles
    for (int cycle = 0; cycle < 10; cycle++) {
        dut->eval();
        m_trace->dump(sim_time++);
    }

    // Print the bit array output after computation
    std::cout << "Output bit array b: {";
    for (int i = 0; i < 8 * dut->len; i++) {
        std::cout << (int32_t)dut->b[i] << ", ";
        
    }
    // Remove the last comma and space, and close the bracket
    std::cout << "\b\b}" << std::endl;  // Using backspace to remove last comma and space

    // Finalize simulation
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}