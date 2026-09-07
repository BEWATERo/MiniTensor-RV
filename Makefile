SHELL := /bin/bash

RTL := rtl/accumulator.sv
TB  := tb/tb_accumulator.sv
SIM := build/accumulator_sim
VCD := results/waveforms/accumulator.vcd

.PHONY: all test lint wave env-check clean

all: test lint

test: $(SIM)
	@mkdir -p results/waveforms
	@./$(SIM)

$(SIM): $(RTL) $(TB)
	@mkdir -p build results/waveforms
	iverilog -g2012 -o $(SIM) $(RTL) $(TB)

lint:
	verilator --lint-only --Wall --Wno-fatal -Irtl $(RTL)

wave: test
	gtkwave $(VCD)

env-check:
	./scripts/check_env.sh

clean:
	rm -rf build $(VCD)
