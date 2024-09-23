
# "Referenced from FIPS-203"
# from bit_reversal import bit_reversal
# import random

# def inverse_ntt(f, q=3329):
    
#     n = 256
#     zetas = [pow(17, bit_reversal(i, 7), q) for i in range(128)] 
#     inv_f = 3303  # Inverse of 128 modulo 3329
#     f_hat = f[:]
#     i = 127
#     length = 2
#     while length <= 128:
#         start = 0
#         while start < n:
#             zeta = zetas[i] 
#             i -= 1
#             for j in range(start, start + length):
#                 t = f_hat[j]
#                 f_hat[j] = (t + f_hat[j + length]) % q  # f[j] = (t + f[j + len]) % q
#                 f_hat[j + length] = (zeta * (f_hat[j + length] - t)) % q  # f[j + len] = zeta * (f[j + len] - t)

#             start += 2 * length

#         length *= 2

#     for j in range(n):
#         f_hat[j] = (f_hat[j] * inv_f) % q

#     return f_hat


# #driverscode
# f_ntt = [random.randint(0, 3328) for _ in range(256)] 
# f_inverse_ntt = inverse_ntt(f_ntt)
# print(f_inverse_ntt)
