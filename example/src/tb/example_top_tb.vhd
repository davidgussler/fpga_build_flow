-- ###############################################################################################
-- # << Example Top Testbench >> #
-- *********************************************************************************************** 
-- Copyright David Gussler 2022
-- *********************************************************************************************** 
-- File     : example_top_tb.vhd
-- Author   : David Gussler - davidnguss@gmail.com 
-- Language : VHDL '08
-- History  :  Date      | Version | Comments 
--            --------------------------------
--            08-07-2022 | 1.0     | Initial
-- *********************************************************************************************** 
-- Description : 
--     Simple Testbench for showing off the automated CLI FPGA flow
-- 
-- ###############################################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity example_top_tb is
end entity example_top_tb;

architecture bench of example_top_tb is
   ----------------------------------------------------------------------------
   -- TB level signals 
   ----------------------------------------------------------------------------
   constant CLK_FREQ   : real := 100.0E+6;
   constant CLK_PERIOD : time := (1.0E9 / CLK_FREQ) * 1 NS;
   constant CLK_TO_Q   : time := 1 NS; 

   signal i_uart_rx : std_logic := '0';
   signal o_uart_tx : std_logic;
   signal i_sw0     : std_logic := '0';
   signal i_sw1     : std_logic := '0';
   signal o_led0    : std_logic;
   signal o_led1    : std_logic;
   signal o_led2    : std_logic;
   signal o_led3    : std_logic;
   signal i_rst     : std_logic := '0';
   signal i_clk     : std_logic := '0';

begin
   ----------------------------------------------------------------------------
   -- Instantiate the DUT 
   ----------------------------------------------------------------------------
   dut : entity work.example_top(rtl) 
    generic map (
        G_VALUE0 => '0',
        G_VALUE1 => '1'
    )
    port map(
        i_uart_rx => i_uart_rx, 
        o_uart_tx => o_uart_tx,
        i_sw0     => i_sw0    ,
        i_sw1     => i_sw1    ,
        o_led0    => o_led0   ,
        o_led1    => o_led1   ,
        o_led2    => o_led2   ,
        o_led3    => o_led3   ,
        i_rst     => i_rst    ,
        i_clk     => i_clk
    );


   ----------------------------------------------------------------------------
   -- Generate the clock
   ----------------------------------------------------------------------------
   clk_process : process 
   begin
      i_clk <= '1';
      wait for CLK_PERIOD / 2;
      i_clk <= '0';
      wait for CLK_PERIOD / 2;
   end process;


   stim_process: process

      ----------------------------------------------------------------------------
      -- Define test procedures
      ----------------------------------------------------------------------------
      -- Fill and empty the fifo. also try writing to full and reading from empty
      procedure test_1 is
      begin

         write_loop : for i in 0 to 50 loop
            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_sw0 <= '1'; 
            i_sw1 <= '0'; 

            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_sw0 <= '0'; 
            i_sw1 <= '1'; 
         end loop;

         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);

      end procedure;


   ----------------------------------------------------------------------------
   -- Call test procedures
   ----------------------------------------------------------------------------
   begin
      test_1;

      wait for CLK_PERIOD * 10;
      assert FALSE
         report "Simulation Ended"
         severity failure;
      wait;
   end process;

end architecture bench;
