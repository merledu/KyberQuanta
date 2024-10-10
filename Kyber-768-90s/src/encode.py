from bitsTobytes import BitsToBytes

def Encode(F, d): 
    if not (1 <= d <= 12):
        raise ValueError("d must be in the range 1 to 12")
    m = 2 ** d if d < 12 else 256 
    b = 0 
    for i in range(256):
        a = F[i] 
        for j in range(d):
            b |= (a % 2) << (i * d + j)
            a = (a - (a % 2)) // 2 
    B = b.to_bytes((256 * d + 7) // 8, "little")     
    return B
F = [1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0] + [0] * 240  
d = 12 
byte_array = Encode(F, d)
print(len(byte_array))