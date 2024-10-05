def BitsToBytes(bits_array, width=8):
    if len(bits_array) % width != 0:
        raise ValueError("The length of bits_array must be a multiple of the specified width.")

    result = [0] * (len(bits_array) // width)  
    
    for i in range(len(bits_array)):
        byte_index = i // width  
        bit_value = bits_array[i]  
        result[byte_index] += bit_value * (1 << (i % width))  

    return result

bits_array = [
    1, 0, 0, 1, 0, 0, 1, 0,
    0, 0, 1, 1, 1, 0, 1, 1,
    1, 0, 1, 1, 1, 0, 0, 1,
]

byte_array = BitsToBytes(bits_array)
# print(byte_array)
