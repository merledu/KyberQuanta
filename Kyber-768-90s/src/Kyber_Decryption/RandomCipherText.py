# import os

# def RandomC(length):

#     return os.urandom(length)

# du = 3
# k = 3
# n = 256
# dv = 2


# ciphertext_length = (du * k * n )//8 + (dv * n) // 8

# ciphertext_length_bit = ciphertext_length * 8

# ciphertext = RandomC(ciphertext_length_bit)


# print(f"Random ciphertext generated: {(ciphertext)}")

import os

def generate_ciphertext():
    # Set the parameters du, dv, k, and n inside the function
    du = 3
    dv = 2
    k = 3
    n = 256

    # Calculate the ciphertext length in bytes
    ciphertext_length = (du * k * n) // 8 + (dv * n) // 8
    # Calculate the ciphertext length in bits
    ciphertext_length_bit = ciphertext_length * 8

    # Generate a random byte string (os.urandom generates bytes, not bits)
    ciphertext = os.urandom(ciphertext_length)

    # Return the generated ciphertext
    return ciphertext

# Generate the random ciphertext
ciphertext = generate_ciphertext()

# Print the ciphertext (in a human-readable format)
print(f"Random ciphertext generated: {ciphertext}")
