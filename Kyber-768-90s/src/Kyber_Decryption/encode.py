from bitsTobytes import bits_to_bytes
def Encode(polynomial):
    """ Convert polynomial string to a list of binary coefficients. """
    import re
    
 
    pattern = re.compile(r'(\d+)X\^(\d+)')
    matches = pattern.findall(polynomial)
    

    max_exp = max(int(exp) for _, exp in matches)
    

    bits = [0] * (max_exp + 1)
    
 
    for coeff, exp in matches:
        bits[int(exp)] = int(coeff)
    
    return bits


polynomial_str = """1X^0 + 0X^1 + 0X^2 + 1X^3 + 0X^4 + 0X^5 + 1X^6 + 0X^7 + 
                    0X^8 + 0X^9 + 1X^10 + 1X^11 + 1X^12 + 0X^13 + 1X^14 + 
                    1X^15 + 1X^16 + 0X^17 + 1X^18 + 1X^19 + 1X^20 + 0X^21 + 
                    0X^22 + 1X^23 + 1X^24 + 0X^25 + 1X^26 + 0X^27 + 0X^28 + 
                    0X^29 + 1X^30 + 1X^31 + 0X^32 + 1X^33 + 0X^34 + 1X^35 + 
                    0X^36 + 1X^37 + 1X^38 + 0X^39 + 0X^40 + 0X^41 + 0X^42 + 
                    0X^43 + 1X^44 + 0X^45 + 1X^46 + 1X^47 + 1X^48 + 1X^49 + 
                    0X^50 + 0X^51 + 1X^52 + 1X^53 + 0X^54 + 0X^55 + 0X^56 + 
                    1X^57 + 1X^58 + 0X^59 + 0X^60 + 1X^61 + 1X^62 + 0X^63 + 
                    1X^64 + 0X^65 + 1X^66 + 1X^67 + 0X^68 + 1X^69 + 0X^70 + 
                    1X^71 + 0X^72 + 0X^73 + 1X^74 + 0X^75 + 1X^76 + 0X^77 + 
                    1X^78 + 1X^79 + 1X^80 + 1X^81 + 1X^82 + 0X^83 + 0X^84 + 
                    0X^85 + 1X^86 + 0X^87 + 0X^88 + 1X^89 + 1X^90 + 1X^91 + 
                    1X^92 + 0X^93 + 0X^94 + 1X^95 + 1X^96 + 0X^97 + 0X^98 + 
                    0X^99 + 1X^100 + 0X^101 + 1X^102 + 0X^103 + 1X^104 + 
                    1X^105 + 0X^106 + 1X^107 + 0X^108 + 1X^109 + 0X^110 + 
                    0X^111 + 0X^112 + 0X^113 + 1X^114 + 0X^115 + 1X^116 + 
                    1X^117 + 0X^118 + 1X^119 + 1X^120 + 1X^121 + 1X^122 + 
                    1X^123 + 0X^124 + 0X^125 + 1X^126 + 0X^127 + 0X^128 + 
                    0X^129 + 1X^130 + 1X^131 + 0X^132 + 1X^133 + 1X^134 + 
                    1X^135 + 1X^136 + 0X^137 + 0X^138 + 1X^139 + 1X^140 + 
                    0X^141 + 0X^142 + 1X^143 + 1X^144 + 1X^145 + 0X^146 + 
                    0X^147 + 1X^148 + 1X^149 + 0X^150 + 1X^151 + 0X^152 + 
                    0X^153 + 1X^154 + 0X^155 + 1X^156 + 1X^157 + 1X^158 + 
                    0X^159 + 1X^160 + 0X^161 + 1X^162 + 1X^163 + 0X^164 + 
                    0X^165 + 1X^166 + 1X^167 + 0X^168 + 1X^169 + 1X^170 + 
                    0X^171 + 0X^172 + 1X^173 + 0X^174 + 1X^175 + 1X^176 + 
                    0X^177 + 1X^178 + 0X^179 + 0X^180 + 1X^181 + 1X^182 + 
                    0X^183 + 1X^184 + 1X^185 + 0X^186 + 0X^187 + 1X^188 + 
                    0X^189 + 1X^190 + 0X^191 + 0X^192 + 0X^193 + 1X^194 + 
                    1X^195 + 0X^196 + 0X^197 + 1X^198 + 1X^199 + 1X^200 + 
                    0X^201 + 1X^202 + 1X^203 + 1X^204 + 1X^205 + 0X^206 + 
                    0X^207 + 0X^208 + 1X^209 + 1X^210 + 0X^211 + 1X^212 + 
                    1X^213 + 0X^214 + 0X^215 + 1X^216 + 0X^217 + 0X^218 + 
                    0X^219 + 1X^220 + 1X^221 + 1X^222 + 1X^223 + 0X^224 + 
                    1X^225 + 0X^226 + 1X^227 + 1X^228 + 0X^229 + 1X^230 + 
                    0X^231 + 1X^232 + 1X^233 + 1X^234 + 0X^235 + 0X^236 + 
                    1X^237 + 0X^238 + 1X^239 + 0X^240 + 0X^241 + 0X^242 + 
                    1X^243 + 1X^244 + 0X^245 + 0X^246 + 1X^247 + 1X^248 + 
                    1X^249 + 1X^250 + 1X^251 + 0X^252 + 1X^253 + 0X^254 + 
                    0X^255"""


binary_list = Encode(polynomial_str)
bytes_array=bits_to_bytes(binary_list)

print(bytes_array)
