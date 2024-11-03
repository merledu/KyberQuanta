# from typing import List

# def bits_to_bytes(bits: List[int]) -> bytes:
#     """
#     Converts a list of bits (0s and 1s) into a bytes object.
#     Groups every 8 bits into a byte, treating the first bit as the LSB.
#     Pads with zeros if the total number of bits isn't a multiple of 8.

#     Parameters:
#     bits (list of int): The list of bits to convert.

#     Returns:
#     bytes: The resulting byte array.
#     """
#     # Pad the bit list if it's not a multiple of 8
#     if len(bits) % 8 != 0:
#         padding = 8 - (len(bits) % 8)
#         bits.extend([0] * padding)
    
#     byte_array = bytearray()
    
#     for i in range(0, len(bits), 8):
#         # Take 8 bits, treat the first bit as LSB by reversing the slice
#         byte_slice = bits[i:i+8]
#         byte_str = ''.join(str(bit) for bit in reversed(byte_slice))
#         byte = int(byte_str, 2)
#         byte_array.append(byte)
    
#     return bytes(byte_array)

# def Encode(F: List[int], d: int) -> bytes:
#     """
#     Encodes a list of integers F into a byte array using d bits per element.

#     Parameters:
#     F (list of int): The list of integers to encode.
#     d (int): Number of bits per element (1 <= d <= 12).

#     Returns:
#     bytes: The encoded byte array.
#     """
#     if not (1 <= d <= 12):
#         raise ValueError("d must be in the range 1 to 12")
    
#     # Calculate the maximum value based on d
#     m = 2 ** d if d < 8 else 256

#     bits = []  # List to accumulate all bits

#     for i, a in enumerate(F):
#         if not (0 <= a < m):
#             raise ValueError(f"Element F[{i}] = {a} is out of range for d = {d}")
#         for j in range(d):
#             bit = (a >> j) & 1  # Extract the j-th bit of a (LSB first)
#             bits.append(bit)  # Append to the bits list

#     # Convert the list of bits to bytes using the bits_to_bytes function
#     B = bits_to_bytes(bits)

#     print("Encoded bytes:", B)
#     print("Length:", len(B))
#     return B

# # Example usage:
# if __name__ == "__main__":
#     # Define F with 256 elements. The first 20 elements are specified, the rest are 0.
#     F = [64, 113, 180, 130, 81, 100, 182, 157, 134, 36, 62, 19, 142, 237, 164, 204, 146, 40, 179, 157, 248, 44, 156, 165, 207, 141, 139, 175, 236, 176, 180, 176, 16, 126, 76, 223, 29, 209, 177, 102, 119, 177, 187, 17, 48, 128, 112, 58, 55, 255, 222, 166, 119, 225, 7, 254, 20, 183, 158, 226, 76, 254, 10, 96, 24, 182, 11, 190, 175, 130, 242, 115, 77, 96, 210, 145, 229, 97, 66, 233, 81, 233, 9, 160, 202, 168, 32, 78, 123, 127, 32, 246, 170, 111, 186, 8, 117, 11, 255, 225, 128, 205, 104, 105, 207, 225, 68, 215, 26, 171, 18, 197, 38, 251, 206, 103, 234, 181, 150, 63, 212, 125, 216, 155, 146, 125, 154, 79, 197, 55, 168, 249, 149, 219, 41, 20, 145, 157, 126, 90, 155, 18, 73, 165, 221, 191, 20, 208, 100, 63, 112, 162, 118, 194, 37, 55, 193, 253, 140, 71, 108, 5, 196, 235, 241, 118, 131, 58, 15, 32, 191, 222, 227, 132, 159, 45, 147, 213, 184, 104, 133, 244, 206, 238, 238, 176, 64, 149, 11, 48, 122, 16, 93, 155, 74, 124, 171, 115, 59, 69, 126, 204, 211, 97, 229, 64, 217, 189, 15, 151, 35, 58, 194, 23, 131, 216, 17, 180, 233, 197, 94, 151, 12, 60, 0, 196, 183, 180, 170, 221, 162, 161, 33, 244, 107, 82, 4, 244, 233, 78, 106, 118, 78, 85, 165, 162, 253, 59, 49, 251, 39, 39, 24, 89, 207, 233]+ [0] * (256 - 152)  # Ensure F has exactly 256 elements
#     d = 8  # Number of bits per element
    
#     byte_array = Encode(F, d)
#     print("Final byte array:", byte_array)
#     print("Final byte array length:", len(byte_array))

from typing import List

def bits_to_bytes(bits: List[int]) -> bytes:
    """
    Converts a list of bits (0s and 1s) into a bytes object.
    Groups every 8 bits into a byte, treating the first bit as the LSB.
    Pads with zeros if the total number of bits isn't a multiple of 8.

    Parameters:
    bits (list of int): The list of bits to convert.

    Returns:
    bytes: The resulting byte array.
    """
    # Pad the bit list if it's not a multiple of 8
    if len(bits) % 8 != 0:
        padding = 8 - (len(bits) % 8)
        bits.extend([0] * padding)
    
    byte_array = bytearray()
    
    for i in range(0, len(bits), 8):
        # Take 8 bits, treat the first bit as LSB by reversing the slice
        byte_slice = bits[i:i+8]
        byte_str = ''.join(str(bit) for bit in reversed(byte_slice))
        byte = int(byte_str, 2)
        byte_array.append(byte)
    
    return bytes(byte_array)


def Encode(F: List[int], d: int) -> bytes:
    """
    Encodes a list of integers F into a byte array using d bits per element.

    Parameters:
    F (list of int): The list of integers to encode.
    d (int): Number of bits per element (1 <= d <= 12).

    Returns:
    bytes: The encoded byte array.
    """
    if not (1 <= d <= 12):
        raise ValueError("d must be in the range 1 to 12")
    
    # Calculate the maximum value based on d
    m = 2 ** d if d < 8 else 256

    bits = []  # List to accumulate all bits

    for i, a in enumerate(F):
        if not (0 <= a < m):
            raise ValueError(f"Element F[{i}] = {a} is out of range for d = {d}")
        for j in range(d):
            bit = (a >> j) & 1  # Extract the j-th bit of a (LSB first)
            bits.append(bit)  # Append to the bits list

    # Convert the list of bits to bytes using the bits_to_bytes function
    B = bits_to_bytes(bits)

    # print("Encoded bytes:", B)
    # print("Length:", len(B))
    return B

if __name__ == "__main__":
    # Define F with 256 elements. The first 152 elements are specified, the rest are 0.
    F = [
        64, 113, 180, 130, 81, 100, 182, 157, 134, 36, 62, 19, 142, 237, 164, 204, 
        146, 40, 179, 157, 248, 44, 156, 165, 207, 141, 139, 175, 236, 176, 180, 
        176, 16, 126, 76, 223, 29, 209, 177, 102, 119, 177, 187, 17, 48, 128, 112, 
        58, 55, 255, 222, 166, 119, 225, 7, 254, 20, 183, 158, 226, 76, 254, 10, 
        96, 24, 182, 11, 190, 175, 130, 242, 115, 77, 96, 210, 145, 229, 97, 66, 
        233, 81, 233, 9, 160, 202, 168, 32, 78, 123, 127, 32, 246, 170, 111, 186, 
        8, 117, 11, 255, 225, 128, 205, 104, 105, 207, 225, 68, 215, 26, 171, 18, 
        197, 38, 251, 206, 103, 234, 181, 150, 63, 212, 125, 216, 155, 146, 125, 
        154, 79, 197, 55, 168, 249, 149, 219, 41, 20, 145, 157, 126, 90, 155, 18, 
        73, 165, 221, 191, 20, 208, 100, 63, 112, 162, 118, 194, 37, 55, 193, 253, 
        140, 71, 108, 5, 196, 235, 241, 118, 131, 58, 15, 32, 191, 222, 227, 132, 
        159, 45, 147, 213, 184, 104, 133, 244, 206, 238, 238, 176, 64, 149, 11, 
        48, 122, 16, 93, 155, 74, 124, 171, 115, 59, 69, 126, 204, 211, 97, 229, 
        64, 217, 189, 15, 151, 35, 58, 194, 23, 131, 216, 17, 180, 233, 197, 94, 
        151, 12, 60, 0, 196, 183, 180, 170, 221, 162, 161, 33, 244, 107, 82, 4, 
        244, 233, 78, 106, 118, 78, 85, 165, 162, 253, 59, 49, 251, 39, 39, 24, 
        89, 207, 233
    ] + [0] * (256 - 152)  # Ensure F has exactly 256 elements
    d = 8  # Number of bits per element

    # Encode the list
    byte_array = Encode(F, d)
    # print("Final byte array length:", len(byte_array))

    # print(byte_array)