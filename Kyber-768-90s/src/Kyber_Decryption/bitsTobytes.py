# # def bits_to_bytes(bits: list[int]) -> bytes:
# #     """
# #     Takes a list of integers (bits) as input.
# #     Groups every 8 bits and converts them to a byte.
# #     Returns the corresponding bytes.
# #     """
# #     assert len(bits) % 8 == 0, "The total number of bits must be a multiple of 8"
    
# #     byte_array = bytearray()
    
# #     for i in range(0, len(bits), 8):
# #         # Take 8 bits, join them into a binary string, and convert to an integer
# #         byte_str = ''.join(str(bit) for bit in bits[i:i+8])
# #         byte = int(byte_str, 2)
# #         byte_array.append(byte)
    
# #     return bytes(byte_array)


# # bits = [1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0] # This is the list of bits you have
# # # Example usage:
# # converted_bytes = bits_to_bytes(bits)

# # # Print the output
# # # print(converted_bytes)


# def bits_to_bytes(bits: list[int]) -> bytes:
#     """
#     Takes a list of integers (bits) as input.
#     Groups every 8 bits and converts them to a byte.
#     Returns the corresponding bytes, padding zeros if necessary.
#     """
#     # Pad the bit list if it's not a multiple of 8
#     if len(bits) % 8 != 0:
#         padding = 8 - (len(bits) % 8)
#         bits.extend([0] * padding)
    
#     byte_array = bytearray()
    
#     for i in range(0, len(bits), 8):
#         # Take 8 bits, join them into a binary string, and convert to an integer
#         byte_str = ''.join(str(bit) for bit in bits[i:i+8])
#         byte = int(byte_str, 2)
#         byte_array.append(byte)
    
#     return bytes(byte_array)

# # Example usage
# bits = [1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0]  # Example bits list
# converted_bytes = bits_to_bytes(bits)
# # print(converted_bytes)


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
# print(byte_array)