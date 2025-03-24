def parse(q, B):
    print("q:", q)
    print("B:", B)
    a = [0 for _ in range(256)]
    i = 0   
    j = 0
    while j < 256:
        d1 = B[i] + 256 * (B[i + 1] % 16)
        d2 = (B[i + 1] // 16) + 16 * B[i + 2] 
        if d1 < q:
            a[j] = d1
            j += 1
        if d2 < q and j < 256:
            a[j] = d2
            j += 1
        i += 3
    return a
q = 3329  
B = [i % 3329 for i in range(768)] 
result = parse(q, B)
print("Result:", result)