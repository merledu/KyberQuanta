from h_hash import _h
from message import generate_message
from randomcoins import generate_random_coins
from publickey import generate_public_key
from g_hash import _g
from encryption_CPAPKE import encryption 
from kdf import kdf
global n , k
n = 256
k = 3
def enc_CCAKEM(pk):
    r = generate_random_coins()
    message = generate_message() 
    m = _h(message)


    H = _h(pk)

    M = H + m
    G_out = _g(M)
    k_bar, r = G_out[0:256], G_out[256:]

    c = encryption(pk, message, r)

    Hash = _h(c)
    K_out = k_bar + Hash
    K = kdf(K_out)
    return c,K
    
public_key = generate_public_key(k, n)
pk = enc_CCAKEM(public_key)
print(pk)