def bits_to_bytes(bits: list[int]) -> bytes:
    """
    Takes a list of integers (bits) as input.
    Groups every 8 bits and converts them to a byte.
    Returns the corresponding bytes, padding zeros if necessary.
    """
    # Pad the bit list if it's not a multiple of 8
    if len(bits) % 8 != 0:
        padding = 8 - (len(bits) % 8)
        bits.extend([0] * padding)
    
    byte_array = bytearray()
    
    for i in range(0, len(bits), 8):
        # Take 8 bits, join them into a binary string, and convert to an integer
        byte_str = ''.join(str(bit) for bit in bits[i:i+8])
        byte = int(byte_str, 2)
        byte_array.append(byte)
    
    return bytes(byte_array)

# Example usage
bits = [1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0]  # Example bits list
converted_bytes = bits_to_bytes(bits)
print(converted_bytes)