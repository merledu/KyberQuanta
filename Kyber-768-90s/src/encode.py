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
