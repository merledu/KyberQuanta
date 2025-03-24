from byteTobits import BytesToBits, hex_to_bytes  # Assumes these functions are defined in your module
import random

def construct_polynomial(coefficients):
    polynomial = " + ".join(f"{coeff}x^{i}" if i > 0 else str(coeff)
                            for i, coeff in enumerate(coefficients) if coeff != 0)
    polynomial = polynomial.replace("x^1 ", "x ").replace("x^0", "1")
    polynomial = polynomial.replace("1x", "x")
    return polynomial

def CBD(byte_array):
    # Convert the byte array into a bit array (implementation provided in byteTobits)
    bit_array = BytesToBits(byte_array)
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
    return polynomial, f

if __name__ == '__main__':
    # Generate 256 random 8-bit numbers (values between 0 and 255),
    # similar to the SV testbench's $random assignment.
    byte_array = [random.randint(0, 255) for _ in range(256)]
    
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
