for i in range(256):
    print(f"        w_poly[{i}] <= v_poly[{i}] - inv_ntt[{i}][15:0];")
