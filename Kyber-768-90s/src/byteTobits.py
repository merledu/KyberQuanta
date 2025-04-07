import os

def bytes_to_bits(B):
    bit_array = [0] * (len(B) * 8)
    B = list(B)

    for i in range(len(B)):
        for j in range(8):
            bit_array[8 * i + j] = B[i] % 2
            B[i] =  B[i] //2
    print(bit_array)
    return bit_array

def bytes_to_bits1(byts: list[int]) -> list[int]:
    """Converts a byte array into an array of bits.

    Bytes are represented as unsigned numbers in the range [0, 255]. Bits are either 0 or 1.

    Args:
        | byts (:type:`list[int]`): The byte array.

    Returns:
        :type:`list[int]`: The array of bits equivalent to the byte array.
    """
    c = byts.copy()

    result: list[int] = []
    for i in range(len(c)):
        for _ in range(8):
            result.append(c[i] & 1)
            c[i] //= 2

    return result
# B = os.urandom(256)
B = [185, 49, 231, 225, 222, 245, 1, 197, 92, 148, 230, 198, 93, 65, 185, 209,
           48, 158, 135, 37, 150, 111, 247, 195, 65, 58, 17, 181, 241, 145, 225, 127,
           214, 158, 9, 44, 112, 92, 232, 162, 104, 69, 243, 190, 224, 192, 181, 0,
           238, 78, 79, 89, 251, 59, 235, 25, 140, 43, 148, 99, 172, 17, 35, 21,
           40, 88, 115, 150, 227, 98, 143, 120, 243, 180, 62, 73, 95, 217, 201, 56,
           152, 84, 37, 155, 29, 164, 203, 205, 226, 17, 68, 188, 187, 209, 196, 176,
           193, 122, 51, 190, 141, 59, 12, 28, 150, 217, 110, 171, 93, 4, 192, 223,
           91, 187, 195, 185, 49, 124, 198, 219, 252, 70, 155, 96, 131, 210, 25, 43]
B=B[::-1]
bytearray = bytes_to_bits(B)
bytearray1= bytes_to_bits1(B)
print(bytearray)
print(bytearray1)