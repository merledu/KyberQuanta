from Crypto.Cipher import AES
from Crypto.Util import Counter
import hashlib
import os

def xof(rho, i, j):
    key = hashlib.sha256(rho).digest()
    
    #  nonce purpose is to ensure that each encryption operation produces unique ciphertexts
    nonce_input = rho + bytes([i]) + bytes([j])
    
    nonce = nonce_input[:16].ljust(16, b'\x00')
    
    ctr = Counter.new(128, initial_value=int.from_bytes(nonce, byteorder='big'))

    cipher = AES.new(key, AES.MODE_CTR, counter=ctr)

    output_length = 64
    output = cipher.encrypt(b'\x00' * output_length)
    
    return output


rho = os.urandom(32)   
i = 42  
j = 7   

output = xof(rho, i, j)

# print("Derived Key (hex):",output)
# print("len",len(output.hex()))
