def parse_polynomial(poly_str):
    import re
    

    pattern = re.compile(r"(\d+)(x\^\d+)?")
    matches = pattern.findall(poly_str)
    
    coefficients = []
    for match in matches:
        if match[0]:  
            coefficients.append(int(match[0]))
    
    return coefficients

def encode_polynomial(coefficients):
    formatted_result = []
    
    for coeff in coefficients:
        
        binary_string = f"{coeff:016b}"
        
       
        first_byte = binary_string[:8]
        second_byte = binary_string[8:]
        
     
        first_byte_list = [int(bit) for bit in first_byte]
        second_byte_list = [int(bit) for bit in second_byte]
 
        formatted_result.append(first_byte_list)
        formatted_result.append(second_byte_list)
    
    return formatted_result

polynomial_str = "792X^0 + 96X^1 + 1554X^2 + 32X^3 + 524X^4 + 1360X^5 + 1290X^6 + 405X^7"
coefficients = parse_polynomial(polynomial_str)

encoded_lists = encode_polynomial(coefficients)


for byte_list in encoded_lists:
    print(byte_list)


# from byteTobits import BytesToBits

# def decode(flat_bit_array, ell):
#     # Debug: print length of flat_bit_array
#     print(f"Length of flat_bit_array: {len(flat_bit_array)}")

#     # Initialize the polynomial coefficients array
#     polynomial = [0] * 256
    
#     # Loop through each coefficient of the polynomial
#     for i in range(256-1):
#         for j in range(ell):
#             index = i * ell + j
#             if index >= len(flat_bit_array):
#                 print(f"Error: Index {index} is out of range.")
#                 return None  # or handle the error appropriately
#             polynomial[i] += flat_bit_array[index] * (2 ** j)
    
#     return polynomial

# # Example 2D bit array input
# bit_array = [
#     [0, 1, 0, 0, 1, 0, 0, 0],
#     [1, 0, 1, 1, 1, 1, 0, 0],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1],
#     [1, 0, 0, 1, 0, 0, 1, 0],
#     [0, 0, 1, 1, 1, 0, 1, 1],
#     [1, 0, 1, 1, 1, 0, 0, 1],
#     [1, 0, 1, 0, 0, 0, 1, 1],
#     [0, 1, 0, 1, 0, 1, 1, 0],
#     [0, 0, 0, 0, 1, 0, 1, 1]
# ]

# flat_bit_array = BytesToBits(bit_array)
# print(flat_bit_array)
# ell = 8  # Bit length for each coefficient
# polynomial = decode(flat_bit_array, ell)
# print(polynomial)
