from Crypto.Cipher import AES
from Crypto.Util import Counter
import hashlib
import os

def XOF(rho, i, j,output_length):
    assert len(rho) == 32, "rho must be 32 bytes."
    key = rho
    nonce_input = bytes([i]) + bytes([j])
    nonce = nonce_input.ljust(12, b'\x00')  
    
    ctr = Counter.new(32, prefix=nonce, initial_value=0, little_endian=False)
    cipher = AES.new(key, AES.MODE_CTR, counter=ctr)
    output = cipher.encrypt(b'\x00' * output_length)
    
    return output

rho = os.urandom(32)  
i = 1 
j = 2  

output = XOF(rho, i, j,256)
# print(len(output))

