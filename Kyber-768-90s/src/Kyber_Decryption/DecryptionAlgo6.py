import numpy as np
from bytesTobits import bytes_to_bits
from decode import Decode
from RandomCipherText import  generate_ciphertext
from RandomSecretKey import generate_secret_key    
from decompress import decompress
from ntt import compute_ntt
# from ntt_inverse import inverse_ntt
# from compress import compress
# from encode import Encode
from bitsTobytes import bits_to_bytes

def DecryptAlgo6():
    du = 11
    dv = 5
    k = 3
    n = 256

    ell = 8
    # ell2 =  (du * k * n) // 8

    C = generate_ciphertext(du,dv)
    Sec = generate_secret_key()

    # line 1 and 2 work 
    d1, d2 = C[:du*k*n//8], C[du*k*n//8:]
    
    d1 = Decode(C, du)
    d2 = Decode(C , dv)
    
    # line 1 work
    xu = []
    for i in d1:
        # print(i)
        u = decompress(i,du)
        xu.append(u)
    # print(xu)

    # line 2 work
    xv = []
    for j in d2:
        v = decompress(j,dv)
        xv.append(v)
    # print(xv)

    # line 3 work
    con = bits_to_bytes(Sec)
    # print(len(con))
    # print(con)
    s = (Decode(con , ell=12))
    # print(s)

    #  line 4 work

    ntt = compute_ntt(xu)
    # print(ntt)

    ntt1 = np.matmul(s,ntt)
    print(ntt1)



    # u = np.array([decompress(pol, d1) for pol in d1])
    # v = decompress(d2, dv)



    # u = decompress(d1 , du)
    # v = decompress(d2 , dv)

    # s = np.array(Decode(Sec , ell=12))

    # ntt = compute_ntt(u)

    # trans = np.matmul(s.T)

    # ntt_1 = inverse_ntt(trans.ntt)
    # ntt_1 = v - ntt_1

    # compressQ = compress(ntt_1,1)

    # m = Encode(compressQ)

    return d2

    
    # return None

a = DecryptAlgo6()
# print(a)
# print(" + ".join(f"{a}X^{i}" for i, coeff in enumerate(a)))