import hashlib

def kdf(input_data):

    if isinstance(input_data, str):
        input_data = input_data.encode()

    hash_object = hashlib.sha256()

    hash_object.update(input_data)

    derived_key = hash_object.digest()

    return derived_key

input_secret = "KyberQuanta" 
derived_key = kdf(input_secret)
print("Derived Key (hex):", derived_key.hex())
