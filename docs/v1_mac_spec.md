# V1 INT8 MAC specification

## Interface behavior

The MAC performs:

```text
acc_next = acc + a * b
```

on a rising clock edge only when `valid=1`.

Priority on every rising edge:

```text
rst > clear > valid > hold
```

- `rst=1`: set `acc` to zero;
- otherwise `clear=1`: set `acc` to zero;
- otherwise `valid=1`: accumulate the signed product;
- otherwise: retain the previous value.

## Numeric format

| Signal | Format |
|---|---|
| `a` | signed INT8 |
| `b` | signed INT8 |
| internal product | signed INT16 |
| `acc` | signed INT32 |

The INT16 product is explicitly sign-extended to INT32 before accumulation.

## Verification plan

- positive multiplication;
- negative multiplication;
- extreme products: `-128 * -128`, `-128 * 127`, and `127 * 127`;
- `valid=0` hold behavior;
- `clear` priority over `valid`;
- `rst` priority over `clear` and `valid`;
- deterministic 500-cycle randomized comparison against a Python model;
- Verilator lint.

## Overflow policy

The fixed-width INT32 accumulator naturally wraps on overflow. Normal supported
workloads are required not to overflow INT32. Saturation will be implemented
later in the requantization/output stage rather than after every MAC operation.

The current parameterization requires:

```text
ACC_W >= 2 * DATA_W
```
