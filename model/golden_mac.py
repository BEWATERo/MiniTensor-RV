"""Integer reference model for the MiniTensor-RV INT8 MAC."""


def wrap_signed(value: int, width: int) -> int:
    """Wrap an integer to a two's-complement signed value of ``width`` bits."""
    mask = (1 << width) - 1
    value &= mask
    sign_bit = 1 << (width - 1)
    return value - (1 << width) if value & sign_bit else value


def mac_step(acc: int, a: int, b: int, *, acc_width: int = 32) -> int:
    """Return one signed integer multiply-accumulate step."""
    if not (-128 <= a <= 127 and -128 <= b <= 127):
        raise ValueError("a and b must be signed INT8 values")
    return wrap_signed(acc + a * b, acc_width)
