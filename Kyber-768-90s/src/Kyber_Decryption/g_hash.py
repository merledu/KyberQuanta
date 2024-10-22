from hashlib import sha512

def _g(input_bytes):
    """
    G: B* -> B^32 * B^32
    """
    hash_output = sha512(input_bytes).digest()
    # Split the hash output into two 32-byte segments
    return hash_output[:32], hash_output[32:]

# Example usage for demonstration
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

# Example to test the updated _g function
_k, r = _g(byte_input)
# print("Output from g-hash:")
# print("k:", _k.hex())
# print("r:", r.hex())
