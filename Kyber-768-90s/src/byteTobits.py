import os

def bytes_to_bits(B):
    bit_array = [0] * (len(B) * 8)  # Initialize a flat array with the correct size

    # Convert bytes object to a list of integers
    B = list(B)

    # Outer loop: Iterate over each byte in B
    for i in range(len(B)):
        # Inner loop: Extract 8 bits from each byte, starting with LSB
        for j in range(8):
            bit_array[8 * i + j] = B[i] % 2  # Extract least significant bit
            B[i] =  B[i] //2  # Divide by 2 to shift right (to get the next bit)
    
    return bit_array

# Example usage
B = os.urandom(32)  # Generates 32 random bytes
bytearray = bytes_to_bits(B)
print(len(bytearray))
print(bytearray)
