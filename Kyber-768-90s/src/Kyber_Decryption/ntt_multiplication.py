import numpy as np

def base_case_multiply(a0, a1, b0, b1, gamma):
    """
    Computes the product of two degree-one polynomials.

    Args:
        a0, a1, b0, b1: Coefficients of the polynomials in Z_q.
        gamma: The modulus, which is used in the quadratic modulus X^2 - gamma.

    Returns:
        c0, c1: Coefficients of the product polynomial.
    """
    c0 = (a0 * b0 + a1 * b1 * gamma) % q  
    c1 = (a0 * b1 + a1 * b0) % q        
    return c0, c1
def multiply_ntts(f, g):
    """
    Computes the product of two NTT representations.

    Args:
        f: Array of coefficients for the first polynomial in Z_q.
        g: Array of coefficients for the second polynomial in Z_q.

    Returns:
        h: Array of coefficients of the product polynomial.
    """
    zetas = [pow(17, bit_reversal(i, 7)+1, 3329) for i in range(128)]
    h = np.zeros(256, dtype=int) 

    for i in range(128):
        h[2 * i], h[2 * i + 1] = base_case_multiply(
            f[2 * i], f[2 * i + 1],
            g[2 * i], g[2 * i + 1],
            zetas[i] 
        )
    return h
def bit_reversal(i, k):
    """
    Perform bit reversal on an unsigned k-bit integer.
    """
    bin_i = bin(i & (2**k - 1))[2:].zfill(k)
    return int(bin_i[::-1], 2)

#driverscode
q = 3329  
f = np.random.randint(0, q, size=256)  
g = np.random.randint(0, q, size=256)  

h = multiply_ntts(f, g)
# print(h)
