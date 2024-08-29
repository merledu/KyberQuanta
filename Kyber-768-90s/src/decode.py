from byteTobits import BytesToBits

def Decode(byte_array, ell=1):
    """ Decode a byte array into a polynomial with coefficients. """
    bits = BytesToBits(byte_array)
    

    coeffs = [0] * 256
    
    for i in range(256):
        coeff_value = 0
        for j in range(ell):
            bit_index = i * ell + j
            if bit_index < len(bits):
                coeff_value += bits[bit_index] * (2 ** j)
        coeffs[i] = coeff_value

    return coeffs

# Example byte array
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


coeffs = Decode(byte_array)


print(" + ".join(f"{coeff}X^{i}" for i, coeff in enumerate(coeffs)))
