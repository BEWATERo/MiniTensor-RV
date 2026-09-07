#!/usr/bin/env bash
set -euo pipefail

echo "== RTL tools =="
verilator --version
iverilog -V 2>&1 | sed -n '1,2p' || true
yosys -V
gtkwave --version 2>&1 | sed -n '1p' || true

echo "== Build tools =="
cmake --version | sed -n '1p'
ninja --version
git --version

echo "== Python =="
PYTHON_BIN="$(dirname "$0")/../.venv/bin/python"
if [[ ! -x "$PYTHON_BIN" ]]; then
    PYTHON_BIN=python3
fi
"$PYTHON_BIN" --version
"$PYTHON_BIN" -c 'import cocotb, numpy, pytest; print("cocotb/numpy/pytest OK")'
