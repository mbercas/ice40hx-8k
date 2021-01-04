#!/usr/bin/env python
# coding: utf-8

"""
VHDL UART TX block
"""

from vunit import VUnit
from pathlib import Path


# Create VUnit instance by parsing command line arguments
vu = VUnit.from_argv()

SRC_PATH = Path(__file__).parent / "src"
TEST_PATH = SRC_PATH / "test"

# Create component library and testbench libary
vu.add_library("uart_lib").add_source_files(SRC_PATH / "*.vhd")
vu.add_library("tb_uart_lib").add_source_files(TEST_PATH / "*.vhd")

# Add all files ending in .vhd in current working directory to library
lib.add_source_files("*.vhd")

# Run vunit function
vu.main()
