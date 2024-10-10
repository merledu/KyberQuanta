
def BitsToBytes(bits_array, width=8):
    if len(bits_array) % width != 0:
        raise ValueError("The length of bits_array must be a multiple of the specified width.")

    result = [0] * (len(bits_array) // width)  # Initialize the byte array with zeros
    
    for i in range(len(bits_array)):
        byte_index = i // width  # Get the index of the byte being constructed
        bit_value = bits_array[i]  # Current bit (0 or 1)
        result[byte_index] += bit_value * (1 << (i % width))  # Add the bit value at the correct position

    return result


# Example usage
bits_array = [1, 0, 0, 1, 0, 0, 1, 0,
              0, 0, 1, 1, 1, 0, 1, 1, 
              1, 0, 1, 1, 1, 0, 0, 1, 
              1, 0, 1, 0, 0, 0, 1, 1, 
              0, 1, 0, 1, 0, 1, 1, 0,
              0, 0, 0, 0, 1, 0, 1, 1, 
              1, 1, 0, 0, 1, 1, 0, 0, 
              0, 1, 1, 0, 0, 1, 1, 0, 
              1, 0, 1, 1, 0, 1, 0, 1,
              0, 0, 1, 0, 1, 0, 1, 1, 
              1, 1, 1, 0, 0, 0, 1, 0, 
              0, 1, 1, 1, 1, 0, 0, 1, 
              1, 0, 0, 0, 1, 0, 1, 0, 
              1, 1, 0, 1, 0, 1, 0, 0, 
              0, 0, 1, 0, 1, 1, 0, 1, 
              1, 1, 1, 1, 0, 0, 1, 0, 
              0, 0, 1, 1, 0, 1, 1, 1, 
              1, 0, 0, 1, 1, 0, 0, 1, 
              1, 1, 0, 0, 1, 1, 0, 1, 
              0, 0, 1, 0, 1, 1, 1, 0, 
              1, 0, 1, 1, 0, 0, 1, 1, 
              0, 1, 1, 0, 0, 1, 0, 1, 
              1, 0, 1, 0, 0, 1, 1, 0, 
              1, 1, 0, 0, 1, 0, 1, 0, 
              0, 0, 1, 1, 0, 0, 1, 1, 
              1, 0, 1, 1, 1, 1, 0, 0, 
              0, 1, 1, 0, 1, 1, 0, 0, 
              1, 0, 0, 0, 1, 1, 1, 1, 
              0, 1, 0, 1, 1, 0, 1, 0, 
              1, 1, 1, 0, 0, 1, 0, 1, 
              0, 0, 0, 1, 1, 0, 0, 1, 
              1, 1, 1, 1, 0, 1, 0, 0] 

byte_array = BitsToBytes(bits_array)
print(byte_array)