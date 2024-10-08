#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vntt.h"  

vluint64_t sim_time = 0;

int main(int argc, char **argv) {
    Verilated::commandArgs(argc, argv);
    Vntt *dut = new Vntt;
    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 99);
    m_trace->open("ntt.vcd");
    // dut->rst_n = 0;  
    // dut->clk = 0;    
    dut->eval();
    m_trace->dump(sim_time++);
    
    
    for (int i = 0; i < 256; i++) {
        dut->f[i] = 0;  
    }
    // Set a few specific values of f
    dut->f[0] = 0;
    dut->f[1] = 1;
    dut->f[2] = 0;
    dut->f[3] = -1;
    dut->f[4] = 0;
    dut->f[5] = 1;
    dut->f[6] = 0;
    dut->f[7] = -1;
    dut->f[8] = 0;  
    dut->f[9] = 1;
    dut->f[10] = 0;
    dut->f[11] = -1;
    dut->f[12] = 0;
    dut->f[100] = -1;
    dut->f[101] = 0;
    dut->f[102] = 1;
    dut->f[103] = 0;
    dut->f[104] = -1;
    dut->f[105] = 0;
    dut->f[106] = 1;
    dut->f[180] = -1;
    dut->f[181] = 0;
    dut->f[182] = 1;
    dut->f[190]= 0;
    dut->f[191] = -1;
    dut->f[205] = 1;
    dut->f[206] = 0;
    dut->f[207] = -1;
    dut->f[208] = 0;
    dut->f[209] = 1;
    dut->f[230] = 0;
    dut->f[231] = -1;
    dut->f[232] = 0;
    dut->f[250]=-1;
    dut->f[251] = 0;
    dut->f[252] = 1;
    dut->f[253] = 0;
    dut->f[254] = 1;
    dut->f[255] = -1;

    // Release reset
    // dut->rst_n = 1;  // Deassert reset
    dut->eval();
    m_trace->dump(sim_time++);

    // Simulate a few clock cycles
    for (int cycle = 0; cycle < 10; cycle++) {
        // dut->clk = 1;  // Clock high
        dut->eval();
        m_trace->dump(sim_time++);
        
        // Output the computed f_hat
        if (cycle == 9) {  // After the computation is done
            std::cout << "Time: " << sim_time << " | ";
            std::cout << "f_hat: {";
            for (int i = 0; i < 256; i++) {
                std::cout << dut->f_hat[i];
                if (i < 255) std::cout << ", ";
            }
            std::cout << "}" << std::endl;
        }

        // dut->clk = 0;  // Clock low
        dut->eval();
        m_trace->dump(sim_time++);
    }

    // Finalize simulation
    dut->final();
    m_trace->close();
    delete dut;

    return 0;
}
