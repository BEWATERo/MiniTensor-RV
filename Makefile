SHELL := /bin/bash

RTL := rtl/accumulator.sv
TB  := tb/tb_accumulator.sv
SIM := build/accumulator_sim
VCD := results/waveforms/accumulator.vcd

.PHONY: all test test-v0 test-mac lint lint-v0 lint-mac synth-mac wave env-check clean

all: test lint

test: test-v0 test-mac

test-v0: $(SIM)
	@mkdir -p results/waveforms
	@./$(SIM)

test-mac:
	@mkdir -p build/cocotb_mac
	@PATH="$(CURDIR)/.venv/bin:$$PATH" $(MAKE) -f tb/Makefile.mac SIM=icarus

$(SIM): $(RTL) $(TB)
	@mkdir -p build results/waveforms
	iverilog -g2012 -o $(SIM) $(RTL) $(TB)

lint: lint-v0 lint-mac

lint-v0:
	verilator --lint-only --Wall --Wno-fatal -Irtl $(RTL)

lint-mac:
	verilator --lint-only --Wall --Wno-fatal -Irtl rtl/mac_int8.sv

synth-mac:
	@mkdir -p results/reports
	yosys -p "read_verilog -sv rtl/mac_int8.sv; prep -top mac_int8; stat" \
		| tee results/reports/mac_int8_yosys.txt

wave: test
	gtkwave $(VCD)

env-check:
	./scripts/check_env.sh

clean:
	rm -rf build $(VCD) dump.vcd results.xml
