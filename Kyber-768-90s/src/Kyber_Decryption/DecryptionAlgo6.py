from bytesTobits import bytes_to_bits
from decode import Decode
from RandomCipherText import  generate_ciphertext
from RandomSecretKey import generate_secret_key    
from decompress import decompress

def DecryptAlgo6():
    du = 3
    dv = 2
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

    s = Decode(Sec , ell=12)
    

    print("hello")
