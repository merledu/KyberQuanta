#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vdecompress_module.h" 

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vdecompress_module *dut = new Vdecompress_module;  

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("decompress.vcd");  

    int x = 1028;  
    int d = 11;    
    dut->x = x;  
    dut->d = d;  

    dut->eval();  
    m_trace->dump(sim_time++);  

    std::cout << "Input x: " << x << ", d: " << d << " | ";
    std::cout << "Decompressed result: " << dut->result << std::endl;
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
