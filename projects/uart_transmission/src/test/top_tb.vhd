-------------------------------------------------------------------------------
-- Title      : Testbench for design "top"
-- Project    :
-------------------------------------------------------------------------------
-- File       : top_tb.vhd
-- Author     : Manuel Berrocal  <manuel@manuellaptop2>
-- Company    :
-- Created    : 2021-01-03
-- Last update: 2021-01-09
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2021, Manuel Berrocal mbercas@gmail.com
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-03  1.0      manuel	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
-- pragma translate_off
library vunit_lib;
use vunit_lib.check_pkg.all;
use vunit_lib.logger_pkg.all;
context vunit_lib.vunit_context;
-- pragma translate_on

library uart_lib;

-------------------------------------------------------------------------------

entity top_tb is
  generic (runner_cfg: string);
end entity top_tb;

-------------------------------------------------------------------------------

architecture behav of top_tb is

  -- component generics
  constant period : integer := 625;

  -- component ports
  signal hw_clk  : std_logic;
  signal led1    : std_logic;
  signal ftdi_tx : std_logic;

  -- clock
  signal clk : std_logic := '1';

begin  -- architecture behav

  -- pragma translate_off

  -- pragma translate_on


  -- component instantiation
  DUT: entity uart_lib.top
    generic map (
      period => period)
    port map (
      hw_clk  => hw_clk,
      led1    => led1,
      ftdi_tx => ftdi_tx);

  -- clock generation
  clk <= not clk after 83 ns;  -- 12MHz clock

  -- waveform generation
  WaveGen_Proc: process
  begin
    test_runner_setup(runner, runner_cfg);
    -- insert signal assignments here

  
    test_runner_cleanup(runner);
  end process WaveGen_Proc;
  

  --test_runner_watchdog(runner, 2 s);

end architecture behav;

-------------------------------------------------------------------------------

configuration top_tb_behav_cfg of top_tb is
  for behav
  end for;
end top_tb_behav_cfg;

-------------------------------------------------------------------------------
