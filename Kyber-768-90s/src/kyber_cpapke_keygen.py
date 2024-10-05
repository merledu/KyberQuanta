import os, random
from encode import Encode
from xof import XOF
from PRF import PRF
from CBD import CBD
from ntt import compute_ntt
from parse import parse
from g_hash import _g
from helpers import flat
from ntt_multiplication import multiply_ntts
import numpy as np


global n, k, q
n = 256
k = 3
q = 3329
    
def __matmul__(a,b):
    return multiply_ntts(a,b)

    
def kyber_cpapke_keygen():
    d = os.urandom(32)
    ghash = _g(d)
    rho = ghash[:32]  
    sigma = ghash[32:] 
    print("rho (as integers):", [byte for byte in rho])
    print("sigma (as integers):", [byte for byte in sigma])
   
    A_hat = [[None] * k for _ in range(k)]
    for i in range(k):
        for j in range(k):
            A_hat[i][j] = parse(q, XOF(rho, j, i, 768))
        
    
    N = 0
    s = [None] * k
    e = [None] * k
    for i in range(k):  
        polynomial, coefficients = CBD(PRF(sigma, bytes([N]), output_len=256))  
        s[i] = coefficients
        N += 1
    
    for i in range(k):
        polynomials, coefficients = CBD(PRF(sigma, bytes([N]), output_len=256))  
        e[i] = coefficients
        N += 1
    s_hat = [None] * k  
    e_hat = [None] * k
    for i in range (k):
        print("check",len(s[i]))
        print("k",i)
        s_hat[i] = compute_ntt(s[i])
        e_hat[i] = compute_ntt(e[i])

    print("A_hat",len(A_hat[0][0]))
    t_hat = [[0] * n for _ in range(k)]  
    for i in range(k):
        for j in range(k):
            for m in range(len(s_hat[j])):
                result = multiply_ntts(A_hat[i][j], s_hat[j])
                for r in range(len(result)):
                    t_hat[i][m] += result[r]
             
    t_hat = [[(t_hat[i][j] + e_hat[i][j]) % q for j in range(len(t_hat[i]))] for i in range(len(t_hat))]
    print("hat",t_hat)
    print(len(t_hat))

    print("rho",rho)
    pk_temp = []
    for i in range(k):
        pk_temp += Encode(t_hat[i], 12)
        print(pk_temp)
    print("pk temp", len(pk_temp))
    pk = pk_temp + list(rho)
    print("pk",pk)
    sk = Encode(s_hat,12)  

    return pk, sk

public_key, secret_key = kyber_cpapke_keygen()
print("pk",public_key)


print("len pk ",len(public_key))
print("sk",secret_key)



