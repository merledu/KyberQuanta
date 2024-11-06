#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VCBD.h"  // Include your generated header file for the SystemVerilog module

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate the CBD module
    VCBD *dut = new VCBD;

    // Enable tracing
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("CBD.vcd");

    // Initialize input byte_array
    uint8_t byte_array[32] = {
        0x00, 0x01, 0x02, 0x03,
        0x04, 0x05, 0x06, 0x07,
        0x08, 0x09, 0x0A, 0x0B,
        0x0C, 0x0D, 0x0E, 0x0F,
        0x10, 0x11, 0x12, 0x13,
        0x14, 0x15, 0x16, 0x17,
        0x18, 0x19, 0x01, 0x1B,
        0x1C, 0x1D, 0x1E, 0x1F
    };

    // Set inputs
    for (int i = 0; i < 32; i++) {
        dut->byte_array[i] = byte_array[i];
    }

    dut->len = 32;  // Set the length of the input array

    // Run simulation for a number of cycles
    for (int cycle = 0; cycle < 10; cycle++) {
        dut->eval();  // Evaluate the module
        m_trace->dump(sim_time++);  // Dump the trace at the current simulation time
    }

    // Retrieve and print output values
    std::cout << "Output f array values:" << std::endl;
    for (int i = 0; i < 256; i++) {
        std::cout << "f[" << i << "] = " << static_cast<int32_t>(dut->f[i]) << std::endl;
    }

    // Finalize simulation
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
