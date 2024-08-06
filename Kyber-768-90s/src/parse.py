def parse(q, b):
    polynomial = ""
    n = len(b)
    a = []
    i = 0
    j = 0
    terms = []
    while j < n:
        d1 = (b[i] + 256) * (b[i+1] % 16)
        d2 = round(b[i+1]/16) + 16 * b[i+2]
        if d1 < q:
            a.insert(j,d1)
            j += 1
        if d2 < q and j < n:
            a.insert(j, d2)
            j += 1
        i += 1

    for n in range(len(a)):
        terms.append(f"{a[n]}X^{n}")
    polynomial = " + ".join(terms)

    return polynomial

byte_stream = [8, 3, 6, 2, 85, 25, 23, 52]
q = 3329
print(parse(q, byte_stream))