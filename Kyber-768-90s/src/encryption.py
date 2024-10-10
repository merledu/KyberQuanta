import os
import math
from publickey import generate_public_key
from byteTobits import BytesToBits
from bitsTobytes import BitsToBytes
from encode import Encode
from message import generate_message
from decode import Decode
from ntt import compute_ntt
from xof import XOF
from compress import compress  # This is the updated compress function
from parse import parse
from decompress import decompress
from ntt_multiplications import multiply_ntts
from CBD import CBD
from PRF import PRF
from ntt_inverse import inverse_ntt

global n, k, q, Nonce, n1 
n = 256
k = 3
q = 3329
Nonce = bytes([1])
n1 = 2

def hex_to_bytes(hex_string):
    if isinstance(hex_string, bytes):
        return hex_string
    elif isinstance(hex_string, str):
        return bytes.fromhex(hex_string)
    else:
        raise TypeError("Input must be a string or bytes")

def BytesToBits(hex_string):
    byte_array = hex_to_bytes(hex_string)
    bits_array = []
    for byte in byte_array:
        for i in range(8):
            bits_array.append((byte >> (7 - i)) & 1)
    return bits_array

def BitsToBytes(bits_array, width=8):
    if len(bits_array) % width != 0:
        raise ValueError("The length of bits_list must be a multiple of the specified width.")
    result = []
    for i in range(0, len(bits_array), width):
        result.append(bits_array[i:i + width])
    return result

public_key = generate_public_key(k, n)
pub_key = BytesToBits(public_key)
public_key1 = BitsToBytes(pub_key)
roh_t = public_key[-32:]
sigma = os.urandom(32)
prf_output = PRF(sigma, Nonce, output_len=256)
bit_array = BytesToBits(prf_output)
prf_byte = BitsToBytes(bit_array)
m = generate_message()
m1 = hex_to_bytes(m)
me = BytesToBits(m1)
message = BitsToBytes(me)
T_hat = [None] * k
for i in range(k):
    T_hat[i] = Decode(public_key1[0:384*k], 12)

A_T = [[None for _ in range(k)] for _ in range(k)]
for i in range(k):
    for j in range(k):
        XOF_output = XOF(roh_t, j, i, n*k)
        A_T[i][j] = parse(3329, XOF_output)

r = [[None for _ in range(k)] for _ in range(k)]
for i in range(k):
    polynomials, coefficients = CBD(prf_byte)
    r[i] = coefficients

e1 = [[None for _ in range(k)] for _ in range(k)]
for i in range(k):
    polynomials, coefficients = CBD(prf_byte)
    e1[i] = coefficients

polynomials, coefficients = CBD(prf_byte)
e2 = coefficients  # Ensure e2 is a list and not a tuple

r_hat = [None] * k
for i in range(k):
    r_hat[i] = compute_ntt(r[i])

m = [None] * k    
for i in range(k):
    m[i] = multiply_ntts(T_hat[i], r_hat[i])

# Matrix multiplication using NTT
def matrix_multiply_ntt(A, B):
    m = len(A)  # Length of the first dimension of A
    n = len(A[0])  # Length of the second dimension of A, i.e., number of elements in each A[i]
    
    # Ensure the dimensions of A and B are compatible for multiplication
    if len(B) != n:
        raise ValueError("Matrices are of incompatible dimensions")

    # Initialize result with None values
    result = [[None for _ in range(len(B[0]))] for _ in range(m)]  # Expecting 2D result

    for i in range(m):
        for j in range(len(B[0])):  # Loop through columns of B
            temp_result = [0] * 256  # Temporary array for 256 coefficients
            for k in range(n):
                mul_result = multiply_ntts(A[i][k], B[k])  # Multiply the NTTs
                temp_result = [(temp_result[idx] + mul_result[idx]) % q for idx in range(256)]
            result[i][j] = temp_result  # Assign the final result for this row-column pair

    return result

# Example usage
u_hat_ntt = matrix_multiply_ntt(A_T, r_hat)
print("u_hat_ntt[0] length:", len(u_hat_ntt[0]))  # This should print 3 if r_hat has 3 columns

# Now applying the inverse NTT to each result
u = [[inverse_ntt(u_hat_ntt[i][j]) for j in range(len(u_hat_ntt[i]))] for i in range(k)]  # Apply inverse NTT to each element
print("u[0] length:", len(u[0]))  # This should be 3 now

# Adjusting u with e1
for i in range(k):
    for j in range(len(u[i])):  # Assuming u[i][j] is now a 1D array of length 256
        # Ensure that e1[i][j] is expanded to a list of 256 elements if it's an integer
        if isinstance(e1[i][j], int):
            e1[i][j] = [e1[i][j]] * 256  
        # Ensure that u[i][j] is also treated as a list
        if isinstance(u[i][j], int):
            u[i][j] = [u[i][j]] * 256
        # Now safely add the corresponding elements
        u[i][j] = [(u[i][j][idx] + e1[i][j][idx]) % q for idx in range(256)]

# Printing final result
print("Final u:", u)
print("u[0] length:", len(u[0]))  # Ensure that this prints 3


m1 = [None]*k
for i in range(k):
    m1[i] = inverse_ntt(m[i])

D = Decode(message, 12) 
Decompress = []
for i in range(len(D)):
    Decompress.append(decompress(D[i], 1))

Compress_u = []
for i in range(k):
    for j in range(k):
        for l in range(256):
            Compress_u.append(compress(u[i][j][l], 10))


v = []
for i in range(k):
    for j in range(256):
        v.append(m1[i][j] + e2[j] + Decompress[j])

compress_v = []      
for i in range(len(v)):  # Should reflect correct number of entries
    compress_v.append(compress(v[i], 4))

# Debugging: Print length of compress_v

c1 = Encode(Compress_u, 12)
c2 = Encode(compress_v, 12)

# Concatenate c1 and c2 into variable c
c = c1 + c2
print(c)