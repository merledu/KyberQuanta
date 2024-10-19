import math
q= 3329    
def compress(x,d):
  print(d)
  print(((2 ** d)/q )*x)
  temp = round(((2 ** d)/q) *x)
  return temp % 2 ** d


print(compress(3331,(math.ceil(math.log2(q))-1))) 
