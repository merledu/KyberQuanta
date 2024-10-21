#include "Vbits_to_bytes.h"  
#include "verilated.h"
#include <iostream>
#include <bitset>

int main(int argc, char **argv, char **env) {
    Verilated::commandArgs(argc, argv);
    
   
    Vbits_to_bytes* top = new Vbits_to_bytes;

   
    const int BYTE_LEN = 32; 
    const int BIT_ARRAY_SIZE = BYTE_LEN * 8;

    
    std::bitset<BIT_ARRAY_SIZE> bit_array; 

    
    for (int i = 0; i < BIT_ARRAY_SIZE; i++) {
        bit_array[i] = (i % 2);
    }

    
    for (int i = 0; i < 8; i++) {
        uint32_t part = 0;
        for (int j = 0; j < 32; j++) {
            part |= (bit_array[i * 32 + j] << j);  
        }
        top->bit_array[i] = part;  
    }

   
    top->eval();

   
    std::cout << "Output bytes: " << std::endl;
    for (int i = 0; i < BYTE_LEN; i++) {
        std::cout << "B[" << i << "] = 0x" << std::hex << (int)(top->B[i]) << std::endl;
    }

    
    top->final();
    delete top;
    return 0;
}
