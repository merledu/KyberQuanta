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
