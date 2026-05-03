--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:59:16 10/18/2025
-- Design Name:   
-- Module Name:   /home/student1/a2bholat/coe758/CacheController_1.1/SDRAMController_tb.vhd
-- Project Name:  CacheController_1.1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: SDRAMController
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
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL; 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SDRAM_controller_tb IS
END SDRAM_controller_tb;
 
ARCHITECTURE behavior OF SDRAM_controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SDRAMController
    PORT(
         clk : IN  std_logic;
         addr : IN  std_logic_vector(15 downto 0);
         wr_rd : IN  std_logic;
         mem_strb : IN  std_logic;
         din : IN  std_logic_vector(7 downto 0);
         dout : INOUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal addr : std_logic_vector(15 downto 0) := (others => '0');
   signal wr_rd : std_logic := '0';
   signal mem_strb : std_logic := '0';
   signal din : std_logic_vector(7 downto 0) := (others => '0');

    --BiDirs
   signal dout : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
    -- Instantiate the Unit Under Test (UUT)
   uut: SDRAMController PORT MAP (
          clk => clk,
          addr => addr,
          wr_rd => wr_rd,
          mem_strb => mem_strb,
          din => din,
          dout => dout
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
      wait for 100 ns;    

      wait for clk_period*10;
        for i in 0 to 31 loop
            addr <= std_logic_vector(to_unsigned(i, 16));
            wr_rd <= '1';
				din <= std_logic_vector(to_unsigned(i*3 mod 256, 8));
            mem_strb <= '1';
            wait for clk_period;
				mem_strb <= '0';
				wait for clk_period;
        end loop;
		  
		
		
		 for i in 0 to 31 loop
            addr <= std_logic_vector(to_unsigned(i, 16));
            wr_rd <= '0';
            mem_strb <= '1';
            wait for clk_period;
            mem_strb <= '0';
				wait for clk_period;
            assert dout = std_logic_vector(to_unsigned(i*3 mod 256, 8));
            report "Read mismatch at address " & integer'image(i) & ", expected " 
				& integer'image(i*3 mod 256) & ", got " & integer'image(to_integer(unsigned(dout)))
            severity error;
        end loop;
		  
		  
		
		-- insert stimulus here 
		
		
      wait;
   end process;

END;

