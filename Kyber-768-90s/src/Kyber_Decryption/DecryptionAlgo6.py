import numpy as np
from bytesTobits import bytes_to_bits
from decode import Decode
from RandomCipherText import  generate_ciphertext
from RandomSecretKey import generate_secret_key    
from decompress import decompress
from ntt import compute_ntt
from ntt_inverse import inverse_ntt
from compress import compress
from encode import Encode

def DecryptAlgo6():
    du = 11
    dv = 5
    k = 3
    n = 256

    ell = 8
    # ell2 =  (du * k * n) // 8

    C = generate_ciphertext
    Sec = generate_secret_key

    d1 = Decode(C, ell)
    d2 = Decode(C + ((du * k * n) // 8)  , ell)

    u = decompress(d1 , du)
    v = decompress(d2 , dv)

    s = np.array(Decode(Sec , ell=12))

    ntt = compute_ntt(u)

    trans = np.matmul(s.T)

    ntt_1 = inverse_ntt(trans.ntt)
    ntt_1 = v - ntt_1

    compressQ = compress(ntt_1,1)

    m = Encode(compressQ)

    return m

    
    # return None

# a = DecryptAlgo6()
# print(a)
    # print("wowaaaaaaaaaaaaaaaaaaaaaaa",u)
