from hashlib import sha256

def _h(input_bytes):
    """
    H: B* -> B^32
    """
    if isinstance(input_bytes, str):
        input_bytes = input_bytes.encode('utf-8')  
    elif isinstance(input_bytes, list):
        input_bytes = bytes(input_bytes)
    return sha256(input_bytes).digest()

input_bits = [
    [1, 1, 1, 1, 0, 0, 1, 0],
    [0, 0, 0, 1, 1, 1, 1, 1],
    [1, 1, 1, 1, 1, 0, 0, 1],
    [1, 0, 1, 1, 0, 0, 1, 1],
    [0, 1, 0, 1, 0, 1, 1, 0],
    [0, 0, 1, 0, 1, 0, 1, 1]
]

flat_input_bits = [bit for sublist in input_bits for bit in sublist]

byte_input = bytes([int(''.join(map(str, flat_input_bits[i:i+8])), 2) for i in range(0, len(flat_input_bits), 8)])

hashed_output = _h(byte_input)

# print(f"Binary representation of hashed output: {hashed_output}")