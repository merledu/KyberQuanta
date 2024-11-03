import numpy as np
import os
from RandomCipherText import  generate_ciphertext
from RandomSecretKey96 import generate_secret_key    
from DecryptionAlgo6 import DecryptAlgo6
from encryption import encryption
from message import generate_message
from g_hash import _g
from h_hash import _h
from kdf import kdf

def DecryptAlgo9():
    k = 3
    n = 256

    sk = generate_secret_key()
    c = generate_message()

    # sk_length = (24 * k * n + 96) // 8
    # print("sk", sk_length)

    # Step 3: Extract public key pk from sk
    pk_start = 12 * k * n // 8
    pk = sk[pk_start:pk_start + (12 * k * n // 8)]

    # Step 4: Extract h from sk
    h_start = (24 * k * n // 8) + 32
    h = sk[h_start:h_start + 32]
    # h_hex = h.hex()

    # Step 5: Extract z from sk
    z_start = (24 * k * n // 8) + 64
    z = sk[z_start:z_start + 32]
    # print("h (hex):", h_hex)

    _m = DecryptAlgo6()  # Assuming this returns a message
    # _m_hex = _m.hex()

    # Unpacking based on the updated _g function
    _k, r = _g(_m + h)  # _g now returns two values

    # Ensure `c` is in bytes when passing to _h
    c_bytes = c.encode() if isinstance(c, str) else c  # Convert to bytes if necessary

    # Call _h with correct byte input
    _H = _h(c_bytes)
    
    _c = encryption(pk, _m, r)
    
    if c_bytes == _c:
        K = kdf(_k + _H)
    else:
        K = kdf(z + _H)

    return K

# Run the DecryptAlgo9 function
a = DecryptAlgo9()
print("Returned k:", a.hex())
