#include <verilated.h>
#include <verilated_vcd_c.h>
#include <iostream>
#include "Vencode.h"  

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    Vencode *dut = new Vencode;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("encode.vcd");

    for (int i = 0; i < 256; i++) {
        dut->F[i] = i; 
    }

    for (int cycle = 0; cycle < 10; cycle++) {
        dut->eval();  
        m_trace->dump(sim_time++);  
    }

    std::cout << "Encoded byte array B:" << std::endl;
    for (int i = 0; i < 32 * 8; i++) { 
        std::cout << "B[" << i << "] = " << static_cast<int>(dut->B[i]) << std::endl;
    }
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
