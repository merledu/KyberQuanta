import os
import math
from byteTobits import BytesToBits

def generate_public_key(k, n):
    length_in_bits = 12 * k * n
    length_in_bytes = length_in_bits // 8 + 32
    public_key = os.urandom(length_in_bytes)
    return public_key



k = 3
n = 256 

# Generate public key
public_key = generate_public_key(k, n)


