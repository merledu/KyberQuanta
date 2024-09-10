import random

def RandomSK(bit_length):
    # Generate a random binary string of the given bit length
    return ''.join(random.choice(['0', '1']) for _ in range(bit_length))

# Given values
k = 3
n = 256

len_of_sk = (k * n * 12)//8 

bit_length = len_of_sk * 8

# Generate the secret key
secret_key = RandomSK(bit_length)

# Display the first 100 bits as an example
print(secret_key[:100])
