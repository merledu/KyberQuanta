import numpy as np

def base_case_multiply(a0, a1, b0, b1, gamma):
    print(a0)
    print(b0)
    c0 = (a0 * b0 + a1 * b1 * gamma) % q  
    c1 = (a0 * b1 + a1 * b0) % q        
    return c0, c1

def multiply_ntts(f, g):
    zetas = np.array([
        2285, 933, 2478, 2455, 344, 2191, 1848, 1089,
        1857, 694, 1300, 3101, 1180, 105, 1805, 165,
        2133, 3240, 1979, 1710, 196, 1176, 240, 1324,
        2176, 2640, 555, 788, 2787, 1233, 445, 3022,
        1896, 2141, 1057, 2231, 1224, 412, 1983, 199,
        2361, 1005, 1797, 132, 233, 2941, 3095, 1468,
        3062, 1835, 1704, 729, 2461, 271, 2395, 1165,
        524, 113, 2973, 2147, 251, 3057, 771, 3059,
        1350, 1187, 1512, 2183, 253, 2037, 1994, 2557,
        1971, 3111, 193, 2167, 3085, 1585, 3086, 3082,
        2898, 1787, 1326, 808, 3128, 1259, 2225, 2038,
        116, 182, 2929, 1376, 1494, 1284, 2491, 1715,
        264, 1840, 2302, 2044, 336, 1501, 1152, 3158,
        1245, 1727, 2565, 1385, 3080, 2202, 566, 2584,
        1042, 2483, 1303, 313, 1775, 2421, 1729, 1383,
        1091, 2105, 1508, 1713, 2468, 1238, 2470, 1491
    ])
    h = np.zeros(256, dtype=int) 

    for i in range(128):
        h[2 * i], h[2 * i + 1] = base_case_multiply(
            f[2 * i], f[2 * i + 1],
            g[2 * i], g[2 * i + 1],
            zetas[i] 
        )
    return h
def bit_reversal(i, k):
    bin_i = bin(i & (2**k - 1))[2:].zfill(k)
    return int(bin_i[::-1], 2)

#driverscode
q = 3329  
f = np.array([
    245, 1023, 3100, 201, 2764, 678, 1455, 2730, 3072, 160, 1340, 2220, 2789, 189, 2556, 1583,
    2598, 173, 1403, 2984, 1600, 1814, 2887, 2054, 920, 2965, 1594, 1472, 3302, 482, 935, 3079,
    1165, 2711, 1153, 2881, 764, 191, 1763, 3102, 2165, 1459, 802, 2279, 1401, 1500, 293, 2821,
    1925, 1706, 2890, 1832, 1603, 987, 1827, 3218, 249, 2876, 1107, 2446, 3013, 140, 1225, 2740,
    1217, 2098, 1259, 1228, 2501, 1581, 1438, 3086, 1746, 2941, 3134, 2543, 2495, 3190, 1417, 2583,
    1829, 2760, 2709, 2273, 2571, 101, 2479, 2784, 3178, 1372, 181, 1109, 2275, 150, 1873, 2542,
    1047, 2230, 1664, 2458, 2888, 1087, 3113, 1297, 1565, 2513, 2686, 1847, 1645, 2779, 2552, 3131,
    752, 1824, 3033, 2184, 2956, 2673, 2385, 3193, 1944, 1638, 2830, 2395, 1559, 2920, 1380, 2263,
    1611, 2910, 3161, 1681, 2107, 1299, 1498, 1702, 2567, 2398, 1842, 2974, 1774, 1118, 2084, 1199,
    1098, 2377, 2237, 1875, 2151, 1042, 2735, 1592, 1275, 1926, 2208, 2381, 3114, 2143, 2540, 1182,
    2492, 1896, 1984, 2050, 1529, 2426, 1385, 3048, 1743, 2641, 1074, 1150, 1661, 2754, 2217, 3018,
    2408, 3320, 1488, 3014, 2925, 2467, 2018, 2875, 3279, 2339, 2963, 2785, 2951, 1690, 2460, 2011,
    2413, 3246, 3207, 1073, 1678, 2175, 3235, 1343, 2732, 1682, 2176, 1860, 3000, 1405, 2261, 1138,
    1846, 1569, 3115, 2517, 1912, 2794, 2834, 2494, 1065, 2878, 2623, 3286, 2442, 2922, 1969, 3225,
    1261, 1049, 2006, 1737, 1764, 2913, 2717, 1481, 2815, 1330, 2212, 1768, 2635, 2898, 3247, 3200,
    1303, 1208, 2019, 1667, 1095, 2869, 3274, 1810, 2763, 3067, 2271, 1772, 1155, 2109, 2370, 1780
])

g = np.array([
    1864, 1825, 1512, 1255, 2094, 2921, 142, 2191, 994, 2510, 104, 1819, 2311, 1151, 144, 1430,
    2322, 843, 1872, 2734, 1621, 823, 243, 2382, 2998, 2268, 1582, 2475, 2238, 2837, 3119, 2677,
    1699, 2345, 1157, 2314, 1376, 1243, 2194, 1184, 2756, 2812, 1156, 3092, 1462, 289, 121, 2560,
    2489, 1992, 2153, 2119, 2067, 1575, 1753, 1724, 145, 3328, 2053, 2702, 1304, 1812, 2434, 1560,
    3008, 2179, 1200, 2293, 1374, 3215, 1424, 2380, 2857, 2978, 2544, 3255, 3272, 3228, 280, 1484,
    3037, 1240, 2483, 2117, 3214, 2012, 993, 2374, 2548, 1192, 2087, 2557, 1970, 2298, 3231, 2566,
    2418, 3004, 2851, 1541, 1902, 1473, 3128, 2214, 3248, 1833, 2715, 2297, 2091, 2781, 1064, 2134,
    1708, 1876, 1721, 1178, 1923, 3262, 2934, 3199, 1234, 1963, 1892, 1469, 1416, 1714, 2013, 1904,
    1730, 2171, 2338, 1328, 1637, 2223, 1452, 1517, 1804, 2116, 1930, 1627, 1976, 2225, 1213, 2294,
    2124, 3001, 1366, 1644, 2487, 2997, 3093, 1878, 3187, 1307, 2659, 2266, 1820, 2511, 1890, 1249,
    2905, 1784, 2100, 1289, 1419, 1392, 2759, 3201, 2621, 2838, 1314, 2584, 1795, 1410, 2309, 3034,
    2718, 2420, 2961, 2631, 2027, 2696, 1642, 2822, 3057, 2681, 2251, 2539, 2783, 3010, 1323, 3111,
    1533, 2112, 1450, 2274, 2981, 2957, 2260, 1674, 1719, 1356, 2158, 1683, 1239, 2336, 1720, 3085,
    2931, 1412, 1785, 1769, 3077, 3202, 3126, 3260, 2809, 1906, 3264, 1983, 1789, 1620, 2648, 1718,
    1577, 2918, 1474, 2186, 1418, 1127, 2189, 1198, 1491, 1365, 2849, 1841, 1483, 3069, 2525, 2456,
    2936, 2017, 3015, 3174, 2482, 1518, 2559, 1741, 2024, 2422, 3062, 1168, 2874, 1388, 1383, 2747
])

hello = multiply_ntts(f, g)
print(hello)