import os

def RandomC(length):

    return os.urandom(length)

du = 3
k = 3
n = 256
dv = 2


ciphertext_length = (du * k * n )//8 + (dv * n) // 8

ciphertext_length_bit = ciphertext_length * 8

ciphertext = RandomC(ciphertext_length_bit)


print(f"Random ciphertext generated: {(ciphertext)}")
