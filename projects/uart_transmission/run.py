#!/usr/bin/env python
# coding: utf-8

"""
VHDL UART TX block
"""

from vunit import VUnit
from pathlib import Path


VUNIT_VHDL_STANDARD = "08"

# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv(vhdl_standard=VUNIT_VHDL_STANDARD)

SRC_PATH = Path(__file__).parent / "src"
TEST_PATH = SRC_PATH / "test"




# Create component library and testbench libary
uart_lib = vu.add_library("uart_lib")
uart_lib.add_source_files(SRC_PATH / "*.vhd")
uart_lib.add_compile_option("ghdl.a_flags", ["--std=02"])

uart_tb_lib = vu.add_library("tb_uart_lib")
uart_tb_lib.add_source_files(TEST_PATH / "*.vhd")
uart_tb_lib.add_compile_option("ghdl.a_flags", ["--std=02"])


# Run vunit function
vu.main()
