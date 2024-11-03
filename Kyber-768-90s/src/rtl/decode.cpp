#include "Vdecode.h"  // Verilated header for the module
#include "verilated.h"
#include <iostream>
#include <cstdint>
#include <vector>

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);

    // Create an instance of the Verilated module
    Vdecode* decode = new Vdecode;

    // Modulus for d = 8, same as used in the Python code
    uint8_t d = 8;
    uint16_t m = (d == 12) ? 3329 : (1 << d);  // Equivalent to 2^d

    // Example byte array input from Python code
    uint8_t byte_array[32] = {
        0x49, 0x8B, 0x0B, 0xFF, 0xFE, 0xCE, 0xB3, 0xC5,
        0x6C, 0xE7, 0x1E, 0x8B, 0xA4, 0x6F, 0x61, 0xEF,
        0x07, 0xCD, 0x2A, 0xCD, 0x46, 0x16, 0x58, 0xBE,
        0xCA, 0xAE, 0x59, 0xA2, 0x78, 0x50, 0xA1, 0xA4
    };

    // Set the input values in the Verilator model
    for (int i = 0; i < 32; i++) {
        decode->byte_array[i] = byte_array[i];
    }
    decode->len = 32;  // Length of the byte array

    // Evaluate the model
    decode->eval();

    // Output the results
    std::vector<uint16_t> coeffs_sv(256);
    std::cout << "Verilator Output (SystemVerilog Decode):" << std::endl;
    for (int i = 0; i < 256; i++) {
        coeffs_sv[i] = decode->coeffs[i];
        std::cout << "Coefficient " << i << ": " << coeffs_sv[i] << std::endl;
    }

    // Clean up
    delete decode;
    return 0;
}
