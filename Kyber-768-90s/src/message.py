import os

def generate_message():
  message = os.urandom(32)
  return message.hex()
message = generate_message()


