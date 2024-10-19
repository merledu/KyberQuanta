#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vbytes_to_bits.h"  

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);

    Vbytes_to_bits *dut = new Vbytes_to_bits;

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("bytes_to_bits.vcd");

    uint8_t B[32] = {
        0xFF, 0x00, 0xEF, 0x01, 0xFF, 0xFF, 0x67, 0x89,
        0x00, 0xFF, 0x55, 0xAA, 0x7E, 0x5A, 0x3C, 0x1E,
        0xFF, 0x0F, 0x33, 0x77, 0x11, 0x22, 0x44, 0x88,
        0x99, 0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x77, 0xFF
    };
    for (int i = 0; i < 32; i++) {
        dut->B[i] = B[i];  
    }

    dut->len = 32;  
    for (int cycle = 0; cycle < 10; cycle++) {
        dut->eval();
        m_trace->dump(sim_time++);
    }
    std::cout << "Output bit array b: {";
    for (int i = 0; i < 8 * dut->len; i++) {
        std::cout << (int32_t)dut->b[i] << ", ";
        
    }
    std::cout << "\b\b}" << std::endl;  
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}