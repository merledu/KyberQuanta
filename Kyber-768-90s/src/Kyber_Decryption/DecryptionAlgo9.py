import numpy as np

from RandomCipherText import  generate_ciphertext
from RandomSecretKey import generate_secret_key    
from DecryptionAlgo6 import DecryptAlgo6


def DecryptAlgo9():
    k = 3
    n = 256

    sk = generate_secret_key()
    c = generate_ciphertext()

    pk = sk + (12 * k * n)/8

    h = sk + (24 * k * n)/8  + 32

    z = sk +(24 * k * n)/8 + 64

    m = DecryptAlgo6()


    return m







    
    # return None

a = DecryptAlgo9()
print(a)
# print(" + ".join(f"{a}X^{i}" for i, coeff in enumerate(a)))