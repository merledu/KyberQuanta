import os
from Crypto.Cipher import AES
from Crypto.Util import Counter

def PRF(sigma, N, output_len):
   
    ctr = Counter.new(128, initial_value=N)

    aes = AES.new(sigma, AES.MODE_CTR, counter=ctr)

    return aes.encrypt(b'\x00' * output_len)

sigma = os.urandom(32)  
N = 1 

pseudorandom_output = PRF(sigma, N, output_len=64)  
print(pseudorandom_output)
