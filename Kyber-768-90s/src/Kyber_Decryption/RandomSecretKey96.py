import random
import numpy as np
from Crypto.Random import get_random_bytes

def generate_polynomial(degree, modulus):
    """Generate a random polynomial of a given degree with coefficients in [0, modulus)."""
    coeffs = np.random.randint(0, modulus, degree)
    return coeffs

def generate_secret_key():
    k = 3
    n = 256
    q = 3329  # Prime modulus

    """Generate the secret key sk for Kyber768."""
    # Generate the secret polynomials s1, s2, s3 and error polynomial e
    s = [generate_polynomial(n, q) for _ in range(k)]  # Secret polynomials
    e = generate_polynomial(n, q)  # Error polynomial

    # Convert the polynomials into a byte format
    sk_bytes = bytearray()
    for poly in s:
        sk_bytes.extend(poly.tobytes())
    sk_bytes.extend(e.tobytes())
    
    # Calculate the length of the secret key in bytes
    sk_length = (24 * k * n + 96) // 8  # Length of the secret key

    # Check if padding is needed
    if len(sk_bytes) < sk_length:
        sk_bytes.extend(get_random_bytes(sk_length - len(sk_bytes)))  # Fill to required length

    return sk_bytes

# Generate and print the first 100 bits of the secret key
sk = generate_secret_key()
# print("Secret Key (first 384 bits):", sk[:48].hex())  # Print in hexadecimal format for readability

# Example calculations for h_start and h
k = 3
n = 256
h_start = 24 * k * n // 8 + 32
h = sk[h_start:h_start + 32]
# print("h_print:", h.hex())
# print("Length of secret key:", len(sk))
