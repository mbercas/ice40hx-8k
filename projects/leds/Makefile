
compile:
	ghdl -a leds.vhdl
	ghdl -a spin1.vhdl

# Synthesize the design.
# NOTE: if ghdl is built as a module, set MODULE to '-m ghdl' or '-m path/to/ghdl.so'
synthesis:
	yosys -m ghdl -p 'ghdl leds; synth_ice40 -json leds.json'

# P&R
placeroute:
	nextpnr-ice40 --hx8k --package ct256 --pcf pinmap.pcf --asc leds.asc --json leds.json

# Generate bitstream
bitstream:
	icepack leds.asc leds.bin

# Program FPGA
program:
	iceprog leds.bin
