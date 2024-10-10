import os
import math
from randomcoins import generate_random_coins
from publickey import generate_public_key
from byteTobits import BytesToBits
from encode import Encode
from message import generate_message
from decode import Decode
from ntt import compute_ntt
from xof import XOF
from compress import compress  
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
def encryption(pk,m,r):
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

    r = [[None for _ in range(256)] for _ in range(3)]
    for i in range(k):
        polynomials, coefficients = CBD(prf_byte)
        r[i] = coefficients

    e1 = [[None for _ in range(256)] for _ in range(3)]
    for i in range(k):
        polynomials, coefficients = CBD(prf_byte)
        e1[i] = coefficients

    polynomials, coefficients = CBD(prf_byte)
    e2 = coefficients  

    r_hat = [None] * k
    for i in range(k):
        r_hat[i] = compute_ntt(r[i])

    m = [None] * k    
    for i in range(k):
        m[i] = multiply_ntts(T_hat[i], r_hat[i])
    print("m",len(m[0]))

    def matrix_multiply_ntt(A, B):
        m = len(A)
        n = len(A[0])
        n_ = len(B)
        l = len(B[0])
        if n != n_:
            raise ValueError("Matrices are of incompatible dimensions")
        result = [None]*3
        for i in range(m):
            for j in range(l):
                temp_result = [0] * 256
                for k in range(n):
                    mul_result = multiply_ntts(A[i][k], B[k])
                    temp_result = [(temp_result[idx] + mul_result[idx]) % q for idx in range(256)]
                result[i] = temp_result  
        return result

    u_hat_ntt = matrix_multiply_ntt(A_T, r_hat)
    print("u_hat_ntt length:", len(u_hat_ntt[0]))

    u = [None]*k
    for i in range(3):
        u[i] = inverse_ntt(u_hat_ntt[i])

    for i in range(k):
            
            u[i] = [(u[i][idx] + e1[i][idx]) % q for idx in range(256)]

    m1 = [None]*k
    for i in range(k):
        m1[i] = inverse_ntt(m[i])

    D = Decode(message, 12) 
    Decompress = []
    for i in range(len(D)):
        Decompress.append(decompress(D[i], 1))

    Compress_u = [[None for _ in range(256)] for _ in range(k)]
    for i in range(k):
            for l in range(256):
                Compress_u[i][l]=(compress(u[i][l], 10))

    print("Length of Compress_u:", len(Compress_u)) 
    print("Length of Decompress:", len(Decompress)) 

    v = [None for _ in range(k * 256)]
    for i in range(k):
        for j in range(256):
            v[i * 256 + j] = (m1[i][j] + e2[j] + Decompress[j])

    print("v", len(v)) 

    compress_v = [None for _ in range(k * 256)]
    for j in range(k):
        for i in range(256):
            compress_v[j * 256 + i] = compress(v[j * 256 + i], 4)

    print("compress_v", len(compress_v))  

    print("Length of compress_v:", compress_v)  

    c1 = bytes(0)
    for i in range(k):
        
        c1 += Encode(Compress_u[i], 10)
    
    c2 = bytes(Encode(compress_v, 4))
    c = bytes(c1 + c2)
    print("c1",type(c1))
    print("C2",type(c2))
    print("c",type(c))

    return c 
pk = generate_public_key(k, n)
m = generate_message()
r = generate_random_coins()

c = encryption(pk,m,r)

print("ciphertext",c)