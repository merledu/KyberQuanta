def parse(q, B):
    a = [0 for _ in range(256)]
    # print("B",B) 
    i = 0   
    j = 0
    while j < 256:
        d1 = B[i] + 256 * (B[i + 1] % 16)
        d2 = (B[i + 1] // 16) + 16 * B[i + 2] 
        if d1 < q:
            a[j] = d1
            j += 1
        if d2 < q and j < 256:
            a[j] = d1
            j += 1

        i += 3
    # print("lennn",len(a))
    return a
