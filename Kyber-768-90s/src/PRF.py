import os
import hashlib
from Crypto.Cipher import AES
from Crypto.Util import Counter

def PRF(sigma, N, output_len=32):
    assert len(sigma) == 32, "Sigma must be 32 bytes for AES-256."
    nonce = N + b'\x00' * (12 - len(N))
    ctr = Counter.new(32, prefix=nonce, initial_value=0, little_endian=False)
    aes = AES.new(sigma, AES.MODE_CTR, counter=ctr)
    # print("AES",aes.encrypt(b'\x00' * output_len))
    return aes.encrypt(b'\x00' * output_len)

sigma = os.urandom(32)
N = bytes([1]) 

pseudorandom_output = PRF(sigma, N, output_len=256)  
# print("Pseudorandom Output:", len(pseudorandom_output))
