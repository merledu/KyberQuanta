import os

def bytes_to_bits(B):
    bit_array = [0] * (len(B) * 8)
    B = list(B)

    for i in range(len(B)):
        for j in range(8):
            bit_array[8 * i + j] = B[i] % 2
            B[i] =  B[i] //2

    return bit_array


B = os.urandom(256)
bytearray = bytes_to_bits(B)
# print(len(bytearray))
# print(bytearray)