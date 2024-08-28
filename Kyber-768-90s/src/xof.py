from hashlib import shake_256

def XOF(input_value: bytes, output_length: int) -> bytes:
    """
    Simple implementation of an Extendable Output Function (XOF) using SHAKE256.
    
    :param input_value: The input value as a byte string.
    :param output_length: The desired length of the output in bytes.
    :return: An extendable output of the specified length.
    """
    shake = shake_256()
    shake.update(input_value)
    
    # Generate an output of the specified length
    return shake.digest(output_length)

# Example usage
input_value = b'some_input'
output_length = 32  # Generate 32 bytes of output
xof_output = XOF(input_value, output_length)
print(f"XOF Output: {xof_output.hex()}")
