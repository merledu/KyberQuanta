def parse(q, B):
    """
    Parse a byte stream into an array of integers suitable as polynomial coefficients.

    Args:
    q (int): Modulus, for ensuring coefficients are in the correct range.
    B (bytes): Byte stream input.

    Returns:
    List[int]: List of integers representing polynomial coefficients.
    """
    a = []  # This will hold the coefficients
    i = 0   # Index for byte stream

    # Continue parsing while there are bytes available and the list of coefficients isn't full
    while i < len(B) - 2:
        # Calculate the two potential coefficients from three bytes
        d1 = B[i] + (B[i + 1] % 16) * 256
        d2 = (B[i + 1] // 16) + B[i + 2] * 16

        # Append to the coefficient list if they are less than q
        if d1 < q:
            a.append(d1)
        if d2 < q and len(a) < 256:  # Ensure we do not exceed 256 coefficients
            a.append(d2)

        # Move to the next set of bytes
        i += 3

    return a

