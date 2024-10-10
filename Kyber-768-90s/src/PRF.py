import os
import hashlib
from Crypto.Cipher import AES
from Crypto.Util import Counter

def PRF(sigma, N, output_len=32):
    # Ensure N is exactly 12 bytes long
    nonce = N + b'\x00' * (12 - len(N))
    
    # Initialize the counter with the nonce (12 bytes) and a 0 for the counter
    ctr = Counter.new(32, prefix=nonce, initial_value=0, little_endian=False)
    
    # Create AES-256 CTR mode object
    aes = AES.new(sigma, AES.MODE_CTR, counter=ctr)
    
    # Encrypt and return pseudorandom output
    return aes.encrypt(b'\x00' * output_len)

# Test case
sigma = os.urandom(32)  # AES-256 requires 32-byte key
N = bytes([1])  # 1-byte input, will be padded to 12 bytes

# Generate pseudorandom output
pseudorandom_output = PRF(sigma, N, output_len=128)
