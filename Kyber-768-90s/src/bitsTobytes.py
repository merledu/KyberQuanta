def bits_to_bytes(bit_array, l):
    """Converts a bit array into a byte array, where l is the number of bytes."""
    # Ensure that the bit_array length is 8 * l (8 bits per byte)
    if len(bit_array) != 8 * l:
        raise ValueError(f"Bit array length must be {8 * l} bits for l = {l} bytes.")

    # Initialize byte array B with l bytes
    B = [0] * l

    # Iterate over each bit in the bit array
    for i in range(len(bit_array)):
        # Update the corresponding byte in B
        B[i // 8] = B[i // 8] + bit_array[i] * (2 ** (7 - (i % 8))) 

    return B

# Example usage
l = 32  # Number of bytes (ℓ)
bit_array = [
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,  # First byte (8 bits)
    0, 1, 0, 1, 1, 0, 0, 1,  # Second byte (8 bits)
    1, 1, 0, 0, 0, 1, 1, 1,  # Third byte (8 bits)
    0, 1, 1, 0, 1, 0, 0, 0, 
    1, 0, 1, 1, 0, 0, 1, 0,  # First byte (8 bits)
    0, 1, 0, 1, 1, 0, 0, 1,  # Second byte (8 bits)
    1, 1, 0, 0, 0, 1, 1, 1,  # Third byte (8 bits)
    0, 1, 1, 0, 1, 0, 0, 0, 
    1, 0, 1, 1, 0, 0, 1, 0,  # First byte (8 bits)
    0, 1, 0, 1, 1, 0, 0, 1,  # Second byte (8 bits)
    1, 1, 0, 0, 0, 1, 1, 1,  # Third byte (8 bits)
    0, 1, 1, 0, 1, 0, 0, 0, 
    1, 0, 1, 1, 0, 0, 1, 0,  # First byte (8 bits)
    0, 1, 0, 1, 1, 0, 0, 1,  # Second byte (8 bits)
    1, 1, 0, 0, 0, 1, 1, 1,  # Third byte (8 bits)
    0, 1, 1, 0, 1, 0, 0, 0,
    1, 0, 1, 1, 0, 0, 1, 0,  # First byte (8 bits)
    0, 1, 0, 1, 1, 0, 0, 1,  # Second byte (8 bits)
    1, 1, 0, 0, 0, 1, 1, 1,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0,
    1, 0, 1, 1, 0, 0, 1, 0  # Fourth byte (8 bits)
]  # Ensure this array has 256 bits (32 bytes x 8 bits/byte)

# Convert the bit array to a byte array
byte_array = bits_to_bytes(bit_array, l)

# Output
print(byte_array)  # Output will be a list of bytes, each representing a group of 8 bits
