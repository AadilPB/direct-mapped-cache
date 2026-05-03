--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:39:41 10/18/2025
-- Design Name:   
-- Module Name:   /home/student1/a2bholat/coe758/CacheController_1.1/Cache_tb.vhd
-- Project Name:  CacheController_1.1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Cache
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL; 
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Cache_tb IS
END Cache_tb;
 
ARCHITECTURE behavior OF Cache_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Cache
    PORT(
         clk : IN  std_logic;
         cpu_addr : IN  std_logic_vector(15 downto 0);
         cpu_wr_rd : IN  std_logic;
         cs : IN  std_logic;
         cpu_dout : IN  std_logic_vector(7 downto 0);
         sdram_dout : IN  std_logic_vector(7 downto 0);
         sdram_din : OUT  std_logic_vector(7 downto 0);
         cpu_din : OUT  std_logic_vector(7 downto 0);
         sdram_addr : OUT  std_logic_vector(15 downto 0);
         mem_wr_rd : OUT  std_logic;
         mem_strb : OUT  std_logic;
         rdy : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal cpu_addr : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_wr_rd : std_logic := '0';
   signal cs : std_logic := '0';
   signal cpu_dout : std_logic_vector(7 downto 0) := (others => '0');
   signal sdram_dout : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal sdram_din : std_logic_vector(7 downto 0);
   signal cpu_din : std_logic_vector(7 downto 0);
   signal sdram_addr : std_logic_vector(15 downto 0);
   signal mem_wr_rd : std_logic;
   signal mem_strb : std_logic;
   signal rdy : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Cache PORT MAP (
          clk => clk,
          cpu_addr => cpu_addr,
          cpu_wr_rd => cpu_wr_rd,
          cs => cs,
          cpu_dout => cpu_dout,
          sdram_dout => sdram_dout,
          sdram_din => sdram_din,
          cpu_din => cpu_din,
          sdram_addr => sdram_addr,
          mem_wr_rd => mem_wr_rd,
          mem_strb => mem_strb,
          rdy => rdy
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
		report "begin" severity note;
		--CPU Write to cache
		cs <= '1';
		cpu_wr_rd <= '1';
		cpu_addr <= x"0004";
		cpu_dout <= x"AA";
		wait for clk_period;
		
		for i in 0 to 70 loop
			wait for clk_period;
		end loop;
		
		cs <= '0';
		wait for clk_period;
		
		cs <= '1';
		cpu_wr_rd <= '0';
		cpu_addr <= x"0004";
		wait for clk_period;
		
		
		assert false report "end of simulation" severity note;
		

      -- insert stimulus here 

      wait;
   end process;

END;
