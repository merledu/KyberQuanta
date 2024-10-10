
"Referenced from FIPS-203"
# from bit_reversal import bit_reversal
import random
from ntt import compute_ntt

def bit_reversal(i, k):
    bin_i = bin(i & (2**k - 1))[2:].zfill(k)
    return int(bin_i[::-1], 2)

def inverse_ntt(coeffs):
    q = 3329
    l, l_upper = 2, 128
    k = l_upper - 1
    zetas = [pow(17, bit_reversal(i, 7), q) for i in range(128)]
    while l <= 128:
        start = 0
        while start < 256:
            zeta = zetas[k]
            k = k - 1
            for j in range(start, start + l):
                t = coeffs[j]
                coeffs[j] = t + coeffs[j + l]
                coeffs[j + l] = (coeffs[j + l] - t) 
                coeffs[j + l] = (zeta * coeffs[j + l]) % q
            start = j + l + 1
        l = l << 1

    f = 3303
    for j in range(256):
        coeffs[j] = (coeffs[j] * f) % 3329
        if coeffs[j] == 3328: 
            coeffs[j] = -1

    return coeffs
print()