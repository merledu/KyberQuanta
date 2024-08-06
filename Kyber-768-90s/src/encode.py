def bytes_to_bits(byte_array):
    """Convert a byte array into a bit array."""
    bit_array = []
    for byte in byte_array:
        for i in range(8):
            bit_array.append((byte >> i) & 1)
    return bit_array

def decode(bits, k):
    """Decode bit array to polynomial coefficients."""
    coefficients = []
    for i in range(256):  
        coefficient = 0
        for j in range(k):
            if i * k + j < len(bits):
                coefficient += bits[i * k + j] * (2 ** j)
        coefficients.append(coefficient)
    return coefficients

def coefficients_to_polynomial(coefficients):
    """Convert list of coefficients to polynomial string."""
    terms = []
    for power, coefficient in enumerate(coefficients):
        if coefficient != 0:
            term = f"{coefficient}x^{power}" if power > 0 else f"{coefficient}"
            terms.append(term)
    polynomial = " + ".join(terms[::-1])
    return polynomial

def coefficients_to_bits(coefficients, k):
    """Convert polynomial coefficients to a bit array."""
    bits = []
    for coefficient in coefficients:
        for j in range(k):
            bits.append((coefficient >> j) & 1)
    return bits

def bits_to_bytes(bits):
    """Convert a bit array to a byte array."""
    byte_array = []
    for i in range(0, len(bits), 8):
        byte = 0
        for j in range(8):
            if i + j < len(bits):
                byte |= (bits[i + j] << j)
        byte_array.append(byte)
    return byte_array

def encode(coefficients, k):
    """Encode polynomial coefficients to byte array."""
    bits = coefficients_to_bits(coefficients, k)
    byte_array = bits_to_bytes(bits)
    return byte_array


byte_array = [
    0b01001000, 0b10111100, 0b00111110, 0b01010010,
    0b01110000, 0b10101101, 0b11011011, 0b10010011,
    0b00101000, 0b10111110, 0b01001000, 0b01110101,
    0b10101100, 0b11011011, 0b10100010, 0b11110101,
    0b01001001, 0b10111010, 0b00101001, 0b01110011,
    0b11101100, 0b10101010, 0b11010110, 0b10100001,
    0b10111011, 0b11101010, 0b01110000, 0b11010101,
    0b11001111, 0b10101100, 0b10010110, 0b10100011
]

k = 8  


bit_array = bytes_to_bits(byte_array)
coefficients = decode(bit_array, k)
polynomial = coefficients_to_polynomial(coefficients)
print("Decoded polynomial:", polynomial)


encoded_byte_array = encode(coefficients, k)
print("Encoded byte array:", encoded_byte_array)