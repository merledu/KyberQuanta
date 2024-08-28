import math

def BytesToBits(byte_array):
    # in this function we are converting byte array into bits
    bits_array = []
    for i in range(8 * len(byte_array)):
        bits_array.append(math.ceil(byte_array[i // 8][i % 8] / (2 ** (i % 8))) % 2)
    return bits_array

def decode_bits(bits, l):
    # Decode will take bits from the function that is byte to bit then will convert each byte of 8 bits into a coefficient then these coefficient will go to 
    # coefficients to polynomial 
    coefficients = []
    for i in range(0, len(bits), l):
        coefficient = 0
        for j in range(l):
            if i + j < len(bits):
                coefficient += bits[i + j] * (2 ** j)
        coefficients.append(coefficient)
    return coefficients

def coefficients_to_polynomial(coefficients):
  #  this function will convert coefficients into polynomial like position of coefficient will tell their degree of polynomial 
    terms = []
    for power, coefficient in enumerate(coefficients):
        if coefficient != 0:
            term = f"{coefficient}x^{power}" if power > 0 else f"{coefficient}"
            terms.append(term)
    polynomial = " + ".join(terms[::-1])
    return polynomial


byte_array = [
    [1, 0, 0, 1, 0, 0, 1, 0],
    [0, 0, 1, 1, 1, 0, 1, 1],
    [1, 0, 1, 1, 1, 0, 0, 1],
    [1, 0, 1, 0, 0, 0, 1, 1],
    [0, 1, 0, 1, 0, 1, 1, 0],
    [0, 0, 0, 0, 1, 0, 1, 1],
    [1, 1, 0, 0, 1, 1, 0, 0],
    [0, 1, 1, 0, 0, 1, 1, 0],
    [1, 0, 1, 1, 0, 1, 0, 1],
    [0, 0, 1, 0, 1, 0, 1, 1],
    [1, 1, 1, 0, 0, 0, 1, 0],
    [0, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 0, 0, 1, 0, 1, 0],
    [1, 1, 0, 1, 0, 1, 0, 0],
    [0, 0, 1, 0, 1, 1, 0, 1],
    [1, 1, 1, 1, 0, 0, 1, 0],
    [0, 0, 1, 1, 0, 1, 1, 1],
    [1, 0, 0, 1, 1, 0, 0, 1],
    [1, 1, 0, 0, 1, 1, 0, 1],
    [0, 0, 1, 0, 1, 1, 1, 0],
    [1, 0, 1, 1, 0, 0, 1, 1],
    [0, 1, 1, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 0, 1, 1, 0],
    [1, 1, 0, 0, 1, 0, 1, 0],
    [0, 0, 1, 1, 0, 0, 1, 1],
    [1, 0, 1, 1, 1, 1, 0, 0],
    [0, 1, 1, 0, 1, 1, 0, 0],
    [1, 0, 0, 0, 1, 1, 1, 1],
    [0, 1, 0, 1, 1, 0, 1, 0],
    [1, 1, 1, 0, 0, 1, 0, 1],
    [0, 0, 0, 1, 1, 0, 0, 1],
    [1, 1, 1, 1, 0, 1, 0, 0]
]


bits = BytesToBits(byte_array)
l = 8  # The number of bits to use for each coefficient

coefficients = decode_bits(bits, l)

polynomial = coefficients_to_polynomial(coefficients)

print(polynomial)


# from byteTobits import BytesToBits

# def decode(flat_bit_array, ell):
#     # Debug: print length of flat_bit_array
#     print(f"Length of flat_bit_array: {len(flat_bit_array)}")

#     # Initialize the polynomial coefficients array
#     polynomial = [0] * 256
    
#     # Loop through each coefficient of the polynomial
#     for i in range(256-1):
#         for j in range(ell):
#             index = i * ell + j
#             if index >= len(flat_bit_array):
#                 print(f"Error: Index {index} is out of range.")
#                 return None  # or handle the error appropriately
#             polynomial[i] += flat_bit_array[index] * (2 ** j)
    
#     return polynomial

# # Example 2D bit array input
# bit_array = [
#     [0, 1, 0, 0, 1, 0, 0, 0],
#     [1, 0, 1, 1, 1, 1, 0, 0],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1]
# ]

# flat_bit_array = BytesToBits(bit_array)
# print(flat_bit_array)
# ell = 8  # Bit length for each coefficient
# polynomial = decode(flat_bit_array, ell)
# print(polynomial)
