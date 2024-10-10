import math
q= 3329     #defined in the specification
def compress(x,d):
  temp = round((2 ** d)/q *x)
  return temp % 2 ** d

print(compress(1383,(math.ceil(math.log2(q))-1))) #d < Ceil(log2(3329))