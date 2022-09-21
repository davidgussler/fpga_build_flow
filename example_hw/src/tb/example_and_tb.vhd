-- ###############################################################################################
-- # << Example And Testbench >> #
-- *********************************************************************************************** 
-- Copyright David Gussler 2022
-- *********************************************************************************************** 
-- File     : example_and_tb.vhd
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

entity example_and_tb is
end entity example_and_tb;

architecture bench of example_and_tb is
   ----------------------------------------------------------------------------
   -- TB level signals 
   ----------------------------------------------------------------------------
   constant CLK_FREQ   : real := 100.0E+6;
   constant CLK_PERIOD : time := (1.0E9 / CLK_FREQ) * 1 NS;
   constant CLK_TO_Q   : time := 1 NS; 

   signal i_a   :  std_logic;
   signal i_b   :  std_logic;
   signal o_res :  std_logic;

   signal i_rst : std_logic;
   signal i_clk : std_logic;

begin
   ----------------------------------------------------------------------------
   -- Instantiate the DUT 
   ----------------------------------------------------------------------------
   dut : entity work.example_and(rtl) 
   port map(
      i_a   => i_a  ,
      i_b   => i_b  ,
      o_res => o_res
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

      ------------------------------------------------------------------------
      -- Define test procedures
      ------------------------------------------------------------------------
      -- Fill and empty the fifo. also try writing to full and reading from empty
      procedure test_1 is
      begin
         report "-- Starting Test --------------------------------------------";

         wait until rising_edge(i_clk);
         i_rst <= '1';
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         i_rst <= '0';

         write_loop : for i in 0 to 50 loop
            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_a <= '0';
            i_b <= '0';

            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_a <= '1';
            i_b <= '0';

            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_a <= '0';
            i_b <= '1';

            wait until rising_edge(i_clk);
            wait until rising_edge(i_clk);
            i_a <= '1';
            i_b <= '1';

         end loop;

         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);
         wait until rising_edge(i_clk);

         report "-- End of Test ----------------------------------------------";
      end procedure;


   ----------------------------------------------------------------------------
   -- Call test procedures
   ----------------------------------------------------------------------------
   begin
      test_1;

      wait for CLK_PERIOD * 50;
      assert FALSE
         report "Simulation Ended"
         severity failure;
      wait;
   end process;

end architecture bench;
