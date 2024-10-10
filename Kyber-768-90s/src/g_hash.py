from hashlib import sha512

def _g(input_bytes):
    if isinstance(input_bytes, str):
        input_bytes = input_bytes.encode('utf-8')  
    elif isinstance(input_bytes, list):
        input_bytes = bytes(input_bytes)
    return sha512(input_bytes).digest()

input_bytes = [
    [1, 1, 1, 1, 0, 0, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 1, 1, 0, 0, 1, 1],
    [0, 1, 0, 1, 0, 1, 1, 0],
    [0, 0, 1, 0, 1, 0, 1, 1]
]
flat_input_bytes = [item for sublist in input_bytes for item in sublist]

byte_input = bytes(flat_input_bytes)
print("g-Hash", _g(byte_input))
binary_representation = ''.join(f'{byte:08b}' for byte in _g(byte_input))

print("lentgh", len(binary_representation))

print("Binary representation:", binary_representation)
rho, sigma = binary_representation[:256], binary_representation[256:]
print("rho",rho)
print("sigma",sigma)