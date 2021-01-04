-------------------------------------------------------------------------------
-- Title      : UART Transmit Example
-- Project    :
-------------------------------------------------------------------------------
-- File       : top.vhd
-- Author     : Manuel Berrocal  <manuel@manuellaptop2>
-- Company    :
-- Created    : 2021-01-02
-- Last update: 2021-01-03
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: UART transmission
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-01-02  1.0      manuel  Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is

  generic (
    period : integer := 625);  -- Period for 1Hz clk generation from 12MHz

  port (
    hw_clk  : in  std_logic;            -- hardware clock (12MHz)
    led1    : out std_logic;            -- LED1
    ftdi_tx : out std_logic);           -- UART lines

end entity top;

architecture behav of top is
  component uart_tc_8n1 is
    port (
      clk       : in  std_logic;
      tx_byte   : in  std_logic_vector(7 downto 0);
      send_data : in  std_logic;
      nreset    : in  std_logic;
      tx_done   : out std_logic;
      tx        : out std_logic);
  end component uart_tc_8n1;

  signal clk       : std_logic;
  signal tx_byte   : std_logic_vector(7 downto 0);
  signal send_data : std_logic;
  signal nreset    : std_logic := '0';
  signal tx_done   : std_logic;
  signal tx        : std_logic;

  signal clk_1     : std_logic;
  signal clk_9600  : std_logic;
  signal cntr_9600 : integer;
  signal cntr_1    : integer;

  constant period_1 : integer := 6000000;
  constant period_9600 : integer := 625;

begin  -- architecture behav

  clk     <= hw_clk;
  ftdi_tx <= tx;

  nreset <= '1';


  -- purpose: Generate low freq clocks from 12MHz clock
  -- type   : sequential
  -- inputs : hw_clk, nreset, cntr_9600,
  -- outputs: clk_1, clk_9600
  slow_clk : process (hw_clk, nreset) is
  begin  -- process slow_clk
    if nreset = '0' then                -- asynchronous reset (active low)
      clk_1     <= '0';
      clk_9600  <= '0';
      cntr_1    <= 0;
      cntr_9600 <= 0;
    elsif hw_clk'event and hw_clk = '1' then  -- rising clock edge

      -- 9600 Hz clock
      cntr_9600 <= cntr_9600 + 1;
      if cntr_9600 = period_9600 then
        clk_9600 <= not clk_9600;
        cntr_9600 <= 0;
      end if;

      -- 1 Hz clock
      cntr_1 <= cntr_1 + 1;
      if cntr_1 = period_1 then
        clk_1 <= not clk_1;
        cntr_1 <= 0;
      end if;
    end if;
  end process slow_clk;

end architecture behav;
