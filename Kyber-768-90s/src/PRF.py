import os
import hashlib
from Crypto.Cipher import AES
from Crypto.Util import Counter

def PRF(sigma, N, output_len=32):
    hashed_sigma = hashlib.sha256(sigma).digest()

    ctr = Counter.new(128, initial_value=N)

    aes = AES.new(hashed_sigma, AES.MODE_CTR, counter=ctr)
    return aes.encrypt(b'00' * output_len).hex()
    

sigma = os.urandom(64)
N = 1 

# Generate pseudorandom output
pseudorandom_output = PRF(sigma, N, output_len=64)  
