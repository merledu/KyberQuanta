# -*- coding: utf-8 -*-
"""ntt.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1WV3iSHzcwu7SxZh6fAVrkkHMbCCX8TIG
"""

import random
def bit_reversal(i, k):
    bin_i = bin(i & (2**k - 1))[2:].zfill(k)
    return int(bin_i[::-1], 2)

def compute_ntt(f, q=3329):
    n = 256
    root_of_unity = 17

    zetas = [pow(root_of_unity, bit_reversal(i, 7), q) for i in range(128)]

    f_hat = f[:]

    i = 1
    length = 128

    while length >= 2:
        start = 0
        while start < n:
            zeta = zetas[i - 1]
            i += 1
            for j in range(start, start + length):
                t = (zeta * f_hat[j + length]) % q
                f_hat[j + length] = (f_hat[j] - t) % q
                f_hat[j] = (f_hat[j] + t) % q
            start += 2 * length
        length //= 2

    return f_hat

#driverscode
f = [random.randint(0, 5000) for _ in range(256)]
print("f",f)
f_ntt = compute_ntt(f)
print(f_ntt)
print(len(f_ntt))