import random
import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

PROJECT_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PROJECT_ROOT / "model"))

from golden_mac import mac_step  # noqa: E402


def encode_signed(value: int, width: int) -> int:
    return value & ((1 << width) - 1)


def decode_signed(value: int, width: int) -> int:
    sign_bit = 1 << (width - 1)
    return value - (1 << width) if value & sign_bit else value


async def clock_step(dut) -> None:
    await RisingEdge(dut.clk)
    # Leave the read-only phase before the next testbench assignment.
    await Timer(1, unit="ns")


def read_acc(dut) -> int:
    return decode_signed(int(dut.acc.value), 32)


@cocotb.test()
async def directed_mac_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.clear.value = 0
    dut.valid.value = 0
    dut.a.value = 0
    dut.b.value = 0
    await clock_step(dut)
    assert read_acc(dut) == 0

    dut.rst.value = 0
    dut.valid.value = 1
    dut.a.value = encode_signed(2, 8)
    dut.b.value = encode_signed(3, 8)
    await clock_step(dut)
    assert read_acc(dut) == 6

    dut.a.value = encode_signed(-3, 8)
    dut.b.value = encode_signed(5, 8)
    await clock_step(dut)
    assert read_acc(dut) == -9

    dut.valid.value = 0
    dut.a.value = encode_signed(127, 8)
    dut.b.value = encode_signed(127, 8)
    await clock_step(dut)
    assert read_acc(dut) == -9, "valid=0 must hold the accumulator"

    dut.valid.value = 1
    dut.clear.value = 1
    await clock_step(dut)
    assert read_acc(dut) == 0, "clear must have priority over valid"


@cocotb.test()
async def boundary_and_priority_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.clear.value = 0
    dut.valid.value = 0
    dut.a.value = 0
    dut.b.value = 0
    await clock_step(dut)

    dut.rst.value = 0
    dut.valid.value = 1

    expected = 0
    for a, b in [(-128, -128), (-128, 127), (127, 127)]:
        dut.a.value = encode_signed(a, 8)
        dut.b.value = encode_signed(b, 8)
        expected = mac_step(expected, a, b)
        await clock_step(dut)
        assert read_acc(dut) == expected

    # clear must discard an otherwise valid extreme product.
    dut.clear.value = 1
    dut.a.value = encode_signed(-128, 8)
    dut.b.value = encode_signed(-128, 8)
    await clock_step(dut)
    assert read_acc(dut) == 0

    # First make the accumulator non-zero.
    dut.clear.value = 0
    dut.a.value = encode_signed(7, 8)
    dut.b.value = encode_signed(9, 8)
    await clock_step(dut)
    assert read_acc(dut) == 63

    # reset has priority over clear, valid, and the input product.
    dut.rst.value = 1
    dut.clear.value = 1
    dut.a.value = encode_signed(127, 8)
    dut.b.value = encode_signed(127, 8)
    await clock_step(dut)
    assert read_acc(dut) == 0


@cocotb.test()
async def randomized_mac_test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    rng = random.Random(0x20260907)

    dut.rst.value = 1
    dut.clear.value = 0
    dut.valid.value = 0
    dut.a.value = 0
    dut.b.value = 0
    await clock_step(dut)
    dut.rst.value = 0

    expected = 0
    for cycle in range(500):
        a = rng.randint(-128, 127)
        b = rng.randint(-128, 127)
        valid = rng.choice([0, 1, 1, 1])
        clear = 1 if cycle in {137, 389} else 0

        dut.a.value = encode_signed(a, 8)
        dut.b.value = encode_signed(b, 8)
        dut.valid.value = valid
        dut.clear.value = clear

        if clear:
            expected = 0
        elif valid:
            expected = mac_step(expected, a, b)

        await clock_step(dut)
        actual = read_acc(dut)
        assert actual == expected, (
            f"cycle={cycle} a={a} b={b} valid={valid} clear={clear} "
            f"expected={expected} actual={actual}"
        )
