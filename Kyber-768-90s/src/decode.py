import os
from  byteTobits import bytes_to_bits

def compute_integer_array(B, d):
    
    assert len(B) == 32 * d, "Input byte array must have size 32d."

    m = 2 ** d 

    b = bytes_to_bits(B)

    F = [0] * 256

    for i in range(256):
        F[i] = sum(b[i * d + j] * (2 ** j) for j in range(d)) % m
    print(F)
    return F

# Example usage
d = 12
B = [
    0x49, 0x8B, 0x0B, 0xFF, 0xFE, 0xCE, 0xB3, 0xC5,
    0x6C, 0xE7, 0x1E, 0x8B, 0xA4, 0x6F, 0x61, 0xEF,
    0x07, 0xCD, 0x2A, 0xCD, 0x46, 0x16, 0x58, 0xBE,
    0xCA, 0xAE, 0x59, 0xA2, 0x78, 0x50, 0xA1, 0xA4
]

# Extend the array with zeros (or repeat values if required for your test case)
B.extend([0x00] * (32 * d - len(B)))  # Pad with zeros to make it 384 bytes

F = compute_integer_array(B, d)