import math
q= 3329     #defined in the specification
def decompress(x,d):
  temp = round(q/(2 ** d) *x)
  return temp

# print(decompress(3,(math.ceil(math.log2(q))-1))) #d < Ceil(log2(3329))
# print((math.ceil(math.log2(q))-1))

#if it helps in creating any ambiguity in decoding then we can randomize
#the value of d being given in a function