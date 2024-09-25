import os, random
from encode import Encode
from xof import XOF
from PRF import PRF
from CBD import CBD
from ntt import compute_ntt
from parse import parse
from g_hash import _g
from helpers import flat


global n, k, q
n = 256
k = 3
q = 3329
    
    
    
def kyber_cpapke_keygen():
    
    d = os.urandom(32)
    # print(d)
    # print(d[:16])
    # print(d[16:])
    # print(d)
    rho, sigma = _g(d[:16]), _g(d[16:])
    # print(rho)
    # print(sigma)
    A_hat = [[None] * k for _ in range(k)]
    # print (A_hat)
    for i in range(k):
        for j in range(k):
            A_hat[i][j] = parse(q, XOF(rho, 256))
    print(A_hat)
            
    N = 0
    s = [None] * k
    e = [None] * k
    for i in range(k):  
        polynomial, coefficients = CBD(PRF(sigma, N, output_len=64))  
        s[i] = coefficients
        N += 1
    
    for i in range(k):
        polynomials, coefficients = CBD(PRF(sigma, N, output_len=64))  
        e[i] = coefficients
        N += 1
    
    s_hat = compute_ntt(flat(s))
    e_hat = compute_ntt(flat(e))

    # print (A_hat)
    # print (s_hat)
    # print (e_hat)
    
    
    # t_hat = [sum(A_hat[i][j] * s_hat[j] for j in range(k)) % q for i in range(k)]
    # t_hat = [(t_hat[i] + e_hat[i]) % q for i in range(n)]


    # pk = Encode(t_hat) + rho  
    # sk = Encode(s_hat)  

    # return pk, sk

# public_key, secret_key = kyber_cpapke_keygen()
kyber_cpapke_keygen()




