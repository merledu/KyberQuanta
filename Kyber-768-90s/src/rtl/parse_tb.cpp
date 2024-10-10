#include <iostream>
#include <verilated.h>
#include "Vparse.h"  

int main(int argc, char** argv, char** env) {
    Verilated::commandArgs(argc, argv);
    Vparse* dut = new Vparse;
    for (int i = 0; i < 768; i++) {
        dut->B[i] = (i % 3329);  
    }
    dut->eval();
    std::cout << "Output a array values:" << std::endl;
    for (int i = 0; i < 256; i++) {
        std::cout << "a[" << i << "] = " << dut->a[i] << std::endl;
    }
    dut->final();
    delete dut;
    return 0;
}
