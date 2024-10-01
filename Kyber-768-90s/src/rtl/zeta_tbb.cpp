/* Created by Hamna Mohiuddin @hamnamohi as a part of the Google Summer of Code 2024 Project. */
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vzeta_calculator.h"

vluint64_t sim_time = 0;

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    // Instantiate the DUT (Device Under Test)
    Vzeta_calculator* dut = new Vzeta_calculator;
    Verilated::traceEverOn(true);
    VerilatedVcdC* m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    // Open the VCD file for tracing signals
    m_trace->open("zetas.vcd");
    
    // Add DUT signals to the trace
    

    // Reset the DUT
    dut->rst_n = 0; // Assert reset
    dut->eval();
    m_trace->dump(sim_time++); // Dump the current simulation time

    // Release reset
    dut->rst_n = 1; // Deassert reset
    dut->eval();
    m_trace->dump(sim_time++); // Dump after releasing reset

    // Simulate a few clock cycles to compute zetas
    for (int cycle = 0; cycle < 100; cycle++) {
        dut->clk = 1; // Clock high
        dut->eval();
        m_trace->dump(sim_time++); // Dump the current simulation time

        // Output the computed zetas
        std::cout << "Time: " << sim_time << " | ";
        std::cout << "Zetas: {";
        for (int i = 0; i < 128; i++) {
            std::cout << dut->zetas[i];
            if (i < 127) std::cout << ", ";
        }
        std::cout << "}" << std::endl;

        dut->clk = 0; // Clock low
        dut->eval();
        m_trace->dump(sim_time++); // Dump the current simulation time
    }

    // Finalize and clean up
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
