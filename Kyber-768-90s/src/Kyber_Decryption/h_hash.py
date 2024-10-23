from hashlib import sha256

def _h(input_bytes):
    """
    H: B* -> B^32
    """
    # Ensure input_bytes is in bytes format
    if isinstance(input_bytes, str):
        input_bytes = input_bytes.encode()  # Encode string to bytes
    return sha256(input_bytes).digest()

# Example usage for demonstration (you can remove this after testing)
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

# Example test for the _h function
# print("h-Hash:", _h(byte_input))
