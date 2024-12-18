from  bitsTobytes import bits_to_bytes

def byte_encoded(F, d):

    b = [0] * (256 * d)

    for i in range(256):
        a = F[i]  
        for j in range(d): 

            b[i * d + j] = a % 2
            a = (a - b[i * d + j]) // 2

    B = bits_to_bytes(b, 32 * d)  
    print(B)
    return B
F = []
for i in range(256):
    F.append(i)
# print("F",F)
d = 8 
byte_array = byte_encoded(F, d)
# print(byte_array)