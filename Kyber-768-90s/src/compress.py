import math
q= 3329     #defined in the specification
def compress(x,d):
  temp = round((2 ** d)/q *x)
  return temp % 2 ** d

