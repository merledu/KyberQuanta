from kyber_cpapke_keygen import kyber_cpapke_keygen
from h_hash import _h
import os

def kyber_ccakem_keygen():
    z = os.urandom(32)
    pk , sk_ = kyber_cpapke_keygen()
    pk_hashed = _h(pk)
    sk = sk_ + pk + pk_hashed + z
    return pk , sk
pk , sk = kyber_ccakem_keygen()
print("------------------------------------------")
print("Public Key CCAKEM:\n",pk)
print("Length of Pk CCAKEM:", len(pk))
print("------------------------------------------")
print("Secret Key CCAKEM:\n",sk)
print("length of secret key",len(sk))