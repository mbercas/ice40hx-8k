-------------------------------------------------------------------------------
-- Title      : UART 8N1 Module, transmit only
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_tx_8n1.vhd
-- Author     : Manuel Berrocal  <manuel@manuellaptop2>
-- Company    : 
-- Created    : 2021-01-02
-- Last update: 2021-01-08
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: UART example module transmit only
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

entity uart_tx_8n1 is

  port (
    clk       : in  std_logic;                     -- input clock
    tx_byte   : in  std_logic_vector(7 downto 0);  -- outgoing byte
    send_data : in  std_logic;                     -- trigger tx
    nreset    : in  std_logic;                     -- async reset, active low
    tx_done   : out std_logic;                     -- outgoing byte sent
    tx        : out std_logic);                    -- tx wire

end entity uart_tx_8n1;

architecture behav of uart_tx_8n1 is

  -- TX states for the state machine
  type TX_SM_STATE is (TX_SM_IDLE, TX_SM_START_TX, TX_SM_TXING,
                       TX_SM_TX_DONE, TX_SM_ERROR);  
  signal state : TX_SM_STATE;

  signal buf_tx    : std_logic_vector(7 downto 0);
  signal tx_bit    : std_logic;

  signal bits_sent : unsigned(4 downto 0);
 

begin  -- architecture behav

  tx <= tx_bit;
  
-- purpose: defines the main state machine for the tx process
-- type   : sequential
-- inputs : clk, nreset, state
-- outputs: state, tx_done, tx_bit
  main : process (clk, nreset) is
  begin  -- process main
    if nreset = '0' then                -- asynchronous reset (active low)
      state     <= TX_SM_IDLE;
      tx_bit    <= '1';
      tx_done   <= '0';
      bits_sent <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge


      case state is 
        -- start sending?
        when TX_SM_IDLE =>
          if send_data = '1'  then
            state   <= TX_SM_START_TX;
            buf_tx  <= tx_byte;
            tx_done <= '1';
          else
            tx_bit  <= '1';
            tx_done <= '0';
          end if;

        -- send start bit (low)
        when TX_SM_START_TX =>
          tx_bit <= '0';
          state  <= TX_SM_TXING;

        -- clock data out
        when TX_SM_TXING =>  
          if bits_sent /= x"8" then
            tx_bit    <= buf_tx(0);
            buf_tx    <= '0' & buf_tx(6 downto 0);
            bits_sent <= bits_sent + 1;

          else
            -- send stop bit
            tx_bit <= '1';
            buf_tx <= (others => '0');
            state  <= TX_SM_TX_DONE;
          end if;

        -- tx done
        when TX_SM_TX_DONE =>
          tx_done <= '1';
          state   <= TX_SM_IDLE;

        when others =>
          state <= TX_SM_ERROR;
      end case;
    end if;
  end process main;


end architecture behav;
