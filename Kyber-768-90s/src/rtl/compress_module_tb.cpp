#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vcompress_module.h"  

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vcompress_module *dut = new Vcompress_module; 

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("compress.vcd");
    dut->x = 3331; 
    dut->d = 11; 
    dut->eval();
    m_trace->dump(sim_time++);
    for (int cycle = 0; cycle < 10; cycle++) {
        dut->eval();
        m_trace->dump(sim_time++);
        if (cycle == 9) { 
            std::cout << "Time: " << sim_time << " | ";
            std::cout << "Compressed value: " << dut->result << std::endl;
        }
        dut->eval();
        m_trace->dump(sim_time++);
    }
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
