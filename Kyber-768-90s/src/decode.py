from byteTobits import BytesToBits

def Decode(byte_array, d):

    # Step 1: Convert byte array to bits
    bits = BytesToBits(byte_array)
    
    # Step 2: Set the modulus m based on the value of d
    if d == 12:
        m = 3329
    else:
        m = 1 << d  # Equivalent to 2^d
    
    # Step 3: Initialize coefficients array F of size 256
    coeffs = [0 for _ in range(256)]
    
    # Step 4: Calculate each coefficient F[i]
    for i in range(256):
        coeff_value = 0
        for j in range(d):
            bit_index = i * d + j
            if bit_index < len(bits):  # Ensure index is within bounds
                coeff_value += bits[bit_index] * (2 ** j)  # Accumulate the bit value
        
        # Apply modulus to the coefficient
        coeffs[i] = coeff_value % m
    return coeffs
    
# Example: Extend the byte array to include more bytes
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
coeffi = Decode(byte_array, 8)
print(coeffi )
