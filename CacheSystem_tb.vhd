--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:05:44 10/19/2025
-- Design Name:   
-- Module Name:   /home/student1/a2bholat/coe758/CacheController_1.1/CacheSystem_tb.vhd
-- Project Name:  CacheController_1.1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CacheSystem
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY CacheSystem_tb IS
END CacheSystem_tb;
 
ARCHITECTURE behavior OF CacheSystem_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CacheSystem
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
			trig : IN std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
	signal trig : std_logic := '0';

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CacheSystem PORT MAP (
          clk => clk,
          reset => reset,
			 trig => trig
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '1';
		trig <= '0';
		wait for 50 ns;	
		reset <= '0';
		wait for 100 ns;
		
		for i in 0 to 100 loop
			trig <= '1';
			wait for 10 ns; 
			trig <= '0';
			wait for 200 ns;
		end loop;
		
		wait;
      

      -- insert stimulus here 

      wait;
   end process;

END;
