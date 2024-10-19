import math
q= 3329     #defined in the specification
def compress(x,d):
  print(d)
  print(((2 ** d)/q )*x)
  temp = round(((2 ** d)/q) *x)
  return temp % 2 ** d

def _compress_ele( x, d):
    """
    Compute round((2^d / q) * x) % 2^d
    """
    t = 1 << d           # This computes 2^d
    y = (t * x + 1664) // 3329  # 1664 = 3329 // 2
    return y % t
print(compress(3331,(math.ceil(math.log2(q))-1))) #d < Ceil(log2(3329))
print(_compress_ele(3331,(math.ceil(math.log2(q))-1))) #d <