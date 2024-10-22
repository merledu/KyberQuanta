import os

def binary_to_bytes(binary_str):
    """Convert a binary string to bytes."""
    padding_length = (8 - len(binary_str) % 8) % 8
    binary_str_padded = binary_str + '0' * padding_length
    byte_array = bytearray()
    for i in range(0, len(binary_str_padded), 8):
        byte = binary_str_padded[i:i+8]
        byte_array.append(int(byte, 2))
    return bytes(byte_array)

def bytes_to_hex(data):
    """Convert bytes to a hexadecimal string."""
    return data.hex()

def main():
    # Define parameters
    n = 256
    k = 3

    # Given secret key (sk) as a binary string (512 bits)
    sk_binary = (
        "1010110011011110001000111100000101001111001010000010000101001000"
        "1011101000011101101100011111010100101100001011111001110101010001"
        "0010111110000101101010101001111100101001100011100100010011100011"
        "0001110111111111000110000001011000000110000000010110010000110001"
        "0111111100011100011101000110111010011101111010110100101010111010"
        "1101001001001001001111100101000111011011010001101101101000111001"
    )

    # Convert binary string to bytes
    sk_bytes = binary_to_bytes(sk_binary)
    # print(f"Original sk length: {len(sk_bytes)} bytes")

    # Reinterpret n/8 as bytes (32 bytes)
    n_div_8 = 32  # bytes

    # Calculate byte offsets based on Option 1
    pk_offset_bytes = 12 * k * (n_div_8 // 8)  # Assuming n_div_8 is in bits
    pk_offset_bytes = 12 * k * (n // 8 // 8)  # Unclear interpretation, better use explicit values

    # Alternatively, assuming n_div_8 is bytes (32 bytes)
    # Recalculate with Option 1
    # n/8 =32 bits =4 bytes
    n_div_8 = 4  # bytes

    pk_offset_bits = 12 * k * n_div_8      # 12*3*4=144 bits
    pk_offset_bytes = pk_offset_bits // 8  # 144 /8=18 bytes

    h_offset_bits = 24 * k * n_div_8 + 32  #24*3*4 +32=288 +32=320 bits
    h_offset_bytes = h_offset_bits // 8      #320 /8=40 bytes

    z_offset_bits = 24 * k * n_div_8 + 64  #24*3*4 +64=288 +64=352 bits
    z_offset_bytes = z_offset_bits // 8      #352 /8=44 bytes

    # Check if sk_bytes is long enough
    required_length = z_offset_bytes
    if len(sk_bytes) < required_length:
        raise ValueError(f"Secret key (sk) must be at least {required_length} bytes long. Current length: {len(sk_bytes)} bytes.")
    else:
        print("sk is sufficiently long.")

    # Extract pk, h, and z
    pk = sk_bytes[pk_offset_bytes:]             # From byte 18 to end
    h = sk_bytes[h_offset_bytes:h_offset_bytes + 32]  # 32-byte segment starting at byte 40
    z = sk_bytes[z_offset_bytes:]               # From byte 44 to end

    # Display the extracted segments
    # print("\nExtracted Segments:")
    # print(f"pk (hex) [from byte {pk_offset_bytes}]: {bytes_to_hex(pk)}")
    # print(f"h (hex) [32 bytes from byte {h_offset_bytes}]: {bytes_to_hex(h)}")
    # print(f"z (hex) [from byte {z_offset_bytes}]: {bytes_to_hex(z)}")


