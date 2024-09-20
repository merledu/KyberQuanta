import random

def generate_secret_key():
    # Set the parameters k, n, and bit length inside the function
    k = 3
    n = 256
    # Calculate the length of the secret key in bytes
    len_of_sk = (k * n * 12) // 8 
    # Calculate the total bit length of the secret key
    bit_length = len_of_sk * 8

    # Generate a random binary string of the calculated bit length
    secret_key = ''.join(random.choice(['0', '1']) for _ in range(bit_length))

    # Return the secret key
    return secret_key

# Generate and print the first 100 bits of the secret key
# print(generate_secret_key()[:100])
