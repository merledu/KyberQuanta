import os

def generate_random_coins():

    random_coins = os.urandom(32)
    return random_coins

random_coins = generate_random_coins()

