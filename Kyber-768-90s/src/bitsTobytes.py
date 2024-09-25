def BitsToBytes(bits_array,width = 8):
    if len(bits_array) % width != 0:
        raise ValueError("The length of bits_list must be a multiple of the specified width.")
    result = []

    for i in range(0, len(bits_array), width):
     
        result.append(bits_array[i:i + width])
    
    return result


bits_array = [1, 0, 0, 1, 0, 0, 1, 0,
              0, 0, 1, 1, 1, 0, 1, 1, 
              1, 0, 1, 1, 1, 0, 0, 1, 
              1, 0, 1, 0, 0, 0, 1, 1, 
              0, 1, 0, 1, 0, 1, 1, 0,
              0, 0, 0, 0, 1, 0, 1, 1, 
              1, 1, 0, 0, 1, 1, 0, 0, 
              0, 1, 1, 0, 0, 1, 1, 0, 
              1, 0, 1, 1, 0, 1, 0, 1,
              0, 0, 1, 0, 1, 0, 1, 1, 
              1, 1, 1, 0, 0, 0, 1, 0, 
              0, 1, 1, 1, 1, 0, 0, 1, 
              1, 0, 0, 0, 1, 0, 1, 0, 
              1, 1, 0, 1, 0, 1, 0, 0, 
              0, 0, 1, 0, 1, 1, 0, 1, 
              1, 1, 1, 1, 0, 0, 1, 0, 
              0, 0, 1, 1, 0, 1, 1, 1, 
              1, 0, 0, 1, 1, 0, 0, 1, 
              1, 1, 0, 0, 1, 1, 0, 1, 
              0, 0, 1, 0, 1, 1, 1, 0, 
              1, 0, 1, 1, 0, 0, 1, 1, 
              0, 1, 1, 0, 0, 1, 0, 1, 
              1, 0, 1, 0, 0, 1, 1, 0, 
              1, 1, 0, 0, 1, 0, 1, 0, 
              0, 0, 1, 1, 0, 0, 1, 1, 
              1, 0, 1, 1, 1, 1, 0, 0, 
              0, 1, 1, 0, 1, 1, 0, 0, 
              1, 0, 0, 0, 1, 1, 1, 1, 
              0, 1, 0, 1, 1, 0, 1, 0, 
              1, 1, 1, 0, 0, 1, 0, 1, 
              0, 0, 0, 1, 1, 0, 0, 1, 
              1, 1, 1, 1, 0, 1, 0, 0]  # This is the list of bits you have
byte_array = BitsToBytes(bits_array)
