import math

def hex_to_bytes(hex_string):
    return bytes.fromhex(hex_string)

def BytesToBits(hex_string):
    byte_array = hex_string
    bits_array = []
    for byte in byte_array:
        for i in range(8):
            bits_array.append((byte >> (7 - i)) & 1)
    return bits_array