from byteTobits import BytesToBits, hex_to_bytes
import random


def construct_polynomial(coefficients):
    polynomial = " + ".join(f"{coeff}x^{i}" if i > 0 else str(coeff) for i, coeff in enumerate(coefficients) if coeff != 0)
    polynomial = polynomial.replace("x^1 ", "x ").replace("x^0", "1")
    polynomial = polynomial.replace("1x", "x")
    return polynomial

def CBD(byte_array):
    
    bit_array = BytesToBits(byte_array)
    n = 2
    j = 0
    f = []
    for i in range(255):
        for j in range(n - 1):
            a = bit_array[(2 * i * n) + j]
            b = bit_array[(2 * i * n) + n + j]
            f.append(a - b)
    polynomial = construct_polynomial(f)
    return polynomial, f
