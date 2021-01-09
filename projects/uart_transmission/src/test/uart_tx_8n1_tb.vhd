-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart_tc_8n1"
-- Project    :
-------------------------------------------------------------------------------
-- File       : uart_tx_8n1_tb.vhd
-- Author     : Manuel Berrocal  <manuel@manuellaptop2>
-- Company    :
-- Created    : 2021-01-08
-- Last update: 2021-01-09
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-08  1.0      manuel	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library uart_lib;
library vunit_lib;
context vunit_lib.vunit_context;
--context vunit_lib.vc_context;

-------------------------------------------------------------------------------

entity uart_tx_8n1_tb is
  generic (runner_cfg : string);
end entity uart_tx_8n1_tb;

-------------------------------------------------------------------------------

architecture test of uart_tx_8n1_tb is

  -- component ports
  signal clk       : std_logic := '1';
  signal tx_byte   : std_logic_vector(7 downto 0);
  signal send_data : std_logic;
  signal nreset    : std_logic;
  signal tx_done   : std_logic;
  signal tx        : std_logic;


begin  -- architecture test

  -- component instantiation
  DUT: entity uart_lib.uart_tx_8n1
    port map (
      clk       => clk,
      tx_byte   => tx_byte,
      send_data => send_data,
      nreset    => nreset,
      tx_done   => tx_done,
      tx        => tx);


  -- clock generation
  clk <= not clk after 83.33 ns;

  -- waveform generation
  wavegen_proc: process
  begin
    test_runner_setup(runner, runner_cfg);
    -- insert signal assignments here

    -- Test 1: tx line remains high while send data does not change,
    --        clk is active, there is an input word, nreset is high,
    --        send data is low
    check(tx = '1');

    send_data <= '0';
    wait for 1 ns;
    check(tx = '1');

    wait until rising_edge(clk);
    check(tx = '1');

    -- Test 2: data is send when the send_data line goes high.
    --         tx line goes down for a clock cycle, and the tx_byte
    --         gets serialized over tx line for the next 8 clock cycles
    --         in the 10th clock cycle the lines goes high again

    -- Test 3: tx line is high at least 2 clock cycles between consecutive words.

    test_runner_cleanup(runner);

  end process wavegen_proc;

  test_runner_watchdog(runner, 20 ms);


end architecture test;

-------------------------------------------------------------------------------

configuration uart_tx_8n1_tb_test_cfg of uart_tx_8n1_tb is
  for test
  end for;
end uart_tx_8n1_tb_test_cfg;

-------------------------------------------------------------------------------
