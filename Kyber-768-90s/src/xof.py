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
input_value = b'f\x8d\xf1\xc4\x92+\xe3j\xe9R\xe39Bw\xffB\x8b"\xa0I+\x07\xa7e\xb4UZ\x03\x7f\xdf\xb6\x0c.A\x08:o\xb1\xf0\xb7\xe3l\x11\xa4\x02+\xc5\xcfg\xbdt\x9c6\x17\xa2u\x8b\x06\x0eE4\xd7\xb8\xfb'
output_length = 256  # Generate 32 bytes of output
# print(XOF(input_value, output_length))