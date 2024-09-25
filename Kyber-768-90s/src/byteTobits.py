import math

def hex_to_bytes(hex_string):
    """Converts hex string to a byte array."""
    return bytes.fromhex(hex_string)

def BytesToBits(hex_string):
    """Converts byte array to a list of bits."""
    byte_array = hex_to_bytes(hex_string)
    bits_array = []
    for byte in byte_array:
        # Convert each byte to its 8-bit binary representation
        for i in range(8):
            bits_array.append((byte >> (7 - i)) & 1)
    return bits_array