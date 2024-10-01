from bitsTobytes import bits_to_bytes

def encode(coefficients, n=256):
    """
    Encode a polynomial with coefficients into a byte array by converting each coefficient to its bit representation.
    Args:
    - coefficients (list[int]): List of polynomial coefficients.
    - n (int): Number of coefficients (default is 256).

    Returns:
    - bytes: The encoded byte array.
    """
    bits = []
    
    # Convert each coefficient to its 32-bit representation
    for coeff in coefficients:
        coeff_bits = []
        for i in range(32):  # Assuming each coefficient fits within 32 bits
            # Collect bits in the correct order (LSB to MSB)
            coeff_bits.append((coeff >> i) & 1)
        # Append the bits in the correct order for this coefficient
        bits.extend(coeff_bits)
    
    # Convert the bits to a byte array
    byte_array = bits_to_bytes(bits)

    return byte_array

# Example usage
coefficients = [
    2, 142, 45, 65, 138, 38, 109, 185, 97, 36, 124, 200, 113, 183, 37, 51,
    73, 20, 205, 185, 31, 52, 57, 165, 243, 177, 209, 245, 55, 13, 45, 13,
    8, 126, 50, 251, 184, 139, 141, 102, 238, 141, 221, 136, 12, 1, 14,
    92, 236, 255, 123, 101, 238, 135, 224, 127, 40, 237, 121, 71, 50, 127,
    80, 6, 24, 109, 208, 125, 245, 65, 79, 206, 178, 6, 75, 137, 167, 134,
    66, 151, 138, 151, 144, 5, 83, 21, 4, 114, 222, 254, 4, 111, 85, 246,
    93, 16, 174, 208, 255, 135, 1, 179, 22, 150, 243, 135, 34, 235, 88, 213,
    72, 163, 100, 223, 115, 230, 87, 173, 105, 252, 43, 190, 27, 217, 73,
    190, 89, 242, 163, 236, 21, 159, 169, 219, 148, 40, 137, 185, 126, 90,
    217, 72, 146, 165, 187, 253, 40, 11, 38, 252, 14, 69, 110, 67, 164,
    236, 131, 191, 49, 226, 54, 160, 35, 215, 143, 110, 193, 92, 240, 4,
    253, 123, 199, 33, 249, 180, 201, 171, 29, 22, 161, 47, 115, 119, 119,
    13, 2, 169, 208, 12, 94, 8, 186, 217, 82, 62, 213, 206, 220, 162, 126,
    51, 203, 134, 167, 2, 155, 189, 240, 233, 196, 92, 67, 232, 193, 27,
    136, 45, 151, 163, 122, 233, 48, 60, 0, 35, 237, 45, 85, 187, 69, 133,
    132, 47, 214, 74, 32, 47, 151, 114, 86, 110, 114, 170, 165, 69, 191,
    220, 140, 223, 228, 228, 24, 154, 243, 151
]
encoded_bytes = encode(coefficients)
print(encoded_bytes)


# def Encode(polynomial):
#     """ Convert polynomial string to a list of binary coefficients. """
#     import re
    
 
#     pattern = re.compile(r'(\d+)X\^(\d+)')
#     matches = pattern.findall(polynomial)
    

#     max_exp = max(int(exp) for _, exp in matches)
    

#     bits = [0] * (max_exp + 1)
    
 
#     for coeff, exp in matches:
#         bits[int(exp)] = int(coeff)
    
#     return bits


# polynomial_str = """1X^0 + 0X^1 + 0X^2 + 1X^3 + 0X^4 + 0X^5 + 1X^6 + 0X^7 + 
#                     0X^8 + 0X^9 + 1X^10 + 1X^11 + 1X^12 + 0X^13 + 1X^14 + 
#                     1X^15 + 1X^16 + 0X^17 + 1X^18 + 1X^19 + 1X^20 + 0X^21 + 
#                     0X^22 + 1X^23 + 1X^24 + 0X^25 + 1X^26 + 0X^27 + 0X^28 + 
#                     0X^29 + 1X^30 + 1X^31 + 0X^32 + 1X^33 + 0X^34 + 1X^35 + 
#                     0X^36 + 1X^37 + 1X^38 + 0X^39 + 0X^40 + 0X^41 + 0X^42 + 
#                     0X^43 + 1X^44 + 0X^45 + 1X^46 + 1X^47 + 1X^48 + 1X^49 + 
#                     0X^50 + 0X^51 + 1X^52 + 1X^53 + 0X^54 + 0X^55 + 0X^56 + 
#                     1X^57 + 1X^58 + 0X^59 + 0X^60 + 1X^61 + 1X^62 + 0X^63 + 
#                     1X^64 + 0X^65 + 1X^66 + 1X^67 + 0X^68 + 1X^69 + 0X^70 + 
#                     1X^71 + 0X^72 + 0X^73 + 1X^74 + 0X^75 + 1X^76 + 0X^77 + 
#                     1X^78 + 1X^79 + 1X^80 + 1X^81 + 1X^82 + 0X^83 + 0X^84 + 
#                     0X^85 + 1X^86 + 0X^87 + 0X^88 + 1X^89 + 1X^90 + 1X^91 + 
#                     1X^92 + 0X^93 + 0X^94 + 1X^95 + 1X^96 + 0X^97 + 0X^98 + 
#                     0X^99 + 1X^100 + 0X^101 + 1X^102 + 0X^103 + 1X^104 + 
#                     1X^105 + 0X^106 + 1X^107 + 0X^108 + 1X^109 + 0X^110 + 
#                     0X^111 + 0X^112 + 0X^113 + 1X^114 + 0X^115 + 1X^116 + 
#                     1X^117 + 0X^118 + 1X^119 + 1X^120 + 1X^121 + 1X^122 + 
#                     1X^123 + 0X^124 + 0X^125 + 1X^126 + 0X^127 + 0X^128 + 
#                     0X^129 + 1X^130 + 1X^131 + 0X^132 + 1X^133 + 1X^134 + 
#                     1X^135 + 1X^136 + 0X^137 + 0X^138 + 1X^139 + 1X^140 + 
#                     0X^141 + 0X^142 + 1X^143 + 1X^144 + 1X^145 + 0X^146 + 
#                     0X^147 + 1X^148 + 1X^149 + 0X^150 + 1X^151 + 0X^152 + 
#                     0X^153 + 1X^154 + 0X^155 + 1X^156 + 1X^157 + 1X^158 + 
#                     0X^159 + 1X^160 + 0X^161 + 1X^162 + 1X^163 + 0X^164 + 
#                     0X^165 + 1X^166 + 1X^167 + 0X^168 + 1X^169 + 1X^170 + 
#                     0X^171 + 0X^172 + 1X^173 + 0X^174 + 1X^175 + 1X^176 + 
#                     0X^177 + 1X^178 + 0X^179 + 0X^180 + 1X^181 + 1X^182 + 
#                     0X^183 + 1X^184 + 1X^185 + 0X^186 + 0X^187 + 1X^188 + 
#                     0X^189 + 1X^190 + 0X^191 + 0X^192 + 0X^193 + 1X^194 + 
#                     1X^195 + 0X^196 + 0X^197 + 1X^198 + 1X^199 + 1X^200 + 
#                     0X^201 + 1X^202 + 1X^203 + 1X^204 + 1X^205 + 0X^206 + 
#                     0X^207 + 0X^208 + 1X^209 + 1X^210 + 0X^211 + 1X^212 + 
#                     1X^213 + 0X^214 + 0X^215 + 1X^216 + 0X^217 + 0X^218 + 
#                     0X^219 + 1X^220 + 1X^221 + 1X^222 + 1X^223 + 0X^224 + 
#                     1X^225 + 0X^226 + 1X^227 + 1X^228 + 0X^229 + 1X^230 + 
#                     0X^231 + 1X^232 + 1X^233 + 1X^234 + 0X^235 + 0X^236 + 
#                     1X^237 + 0X^238 + 1X^239 + 0X^240 + 0X^241 + 0X^242 + 
#                     1X^243 + 1X^244 + 0X^245 + 0X^246 + 1X^247 + 1X^248 + 
#                     1X^249 + 1X^250 + 1X^251 + 0X^252 + 1X^253 + 0X^254 + 
#                     0X^255"""


# binary_list = Encode(polynomial_str)
# bytes_array=bits_to_bytes(binary_list)

# # print(bytes_array)

