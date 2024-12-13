import os
from  byteTobits import bytes_to_bits

def compute_integer_array(B, d):
    
    assert len(B) == 32 * d, "Input byte array must have size 32d."

    m = 2 ** d 

    b = bytes_to_bits(B)

    F = [0] * 256

    for i in range(256):
        F[i] = sum(b[i * d + j] * (2 ** j) for j in range(d)) % m

    return F

# Example usage
d = 12
B = os.urandom(32 * d) 

F = compute_integer_array(B, d)
print(F)