from byteTobits import bytes_to_bits  # Assumes these functions are defined in your module
import random

def construct_polynomial(coefficients):
    polynomial = " + ".join(f"{coeff}x^{i}" if i > 0 else str(coeff)
                            for i, coeff in enumerate(coefficients) if coeff != 0)
    polynomial = polynomial.replace("x^1 ", "x ").replace("x^0", "1")
    polynomial = polynomial.replace("1x", "x")
    return polynomial

def CBD(byte_array):
    # Convert the byte array into a bit array (implementation provided in byteTobits)
    bit_array = bytes_to_bits(byte_array)
    n = 2
    f = []
    # The loop structure here mirrors the SV implementation:
    # With n=2, the inner loop runs once (j=0) per iteration.
    for i in range(256):
        for j in range(n - 1):  # This loop executes once, for j = 0.
            a = bit_array[(2 * i * n) + j]
            b = bit_array[(2 * i * n) + n + j]
            f.append(a - b)
    polynomial = construct_polynomial(f)
    print(byte_array[0])
    return polynomial, f

if __name__ == '__main__':
    # Generate 256 random 8-bit numbers (values between 0 and 255),
    # similar to the SV testbench's $random assignment.
    byte_array = [ 
            185, 49, 231, 225, 222, 245, 1, 197, 92, 148, 230, 198, 93, 65, 185, 209,
            48, 158, 135, 37, 150, 111, 247, 195, 65, 58, 17, 181, 241, 145, 225, 127,
            214, 158, 9, 44, 112, 92, 232, 162, 104, 69, 243, 190, 224, 192, 181, 0,
            238, 78, 79, 89, 251, 59, 235, 25, 140, 43, 148, 99, 172, 17, 35, 21,
            40, 88, 115, 150, 227, 98, 143, 120, 243, 180, 62, 73, 95, 217, 201, 56,
            152, 84, 37, 155, 29, 164, 203, 205, 226, 17, 68, 188, 187, 209, 196, 176,
            193, 122, 51, 190, 141, 59, 12, 28, 150, 217, 110, 171, 93, 4, 192, 223,
            91, 187, 195, 185, 49, 124, 198, 219, 252, 70, 155, 96, 131, 210, 25, 43]
    byte_array = byte_array[::-1]
    
    # Call the CBD function using the generated input.
    polynomial, f = CBD(byte_array)
    
    # Display the input byte_array.
    print("Input byte_array:")
    print(byte_array)
    
    # Display the computed polynomial.
    print("\nOutput polynomial:")
    print(polynomial)
    
    # Display the computed f array in a format similar to the SV $display loop.
    print("\nOutput f array:")
    for i, diff in enumerate(f):
        print(f"f[{i}] = {diff}")
