--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:53:15 10/20/2025
-- Design Name:   
-- Module Name:   /home/student1/a2bholat/coe758/CacheController_1.1/CacheSystem_tb_4.vhd
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
 
ENTITY CacheSystem_tb_4 IS
END CacheSystem_tb_4;
 
ARCHITECTURE behavior OF CacheSystem_tb_4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CacheSystem
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         trigger : OUT  std_logic;
         cpu_addr_probe : OUT  std_logic_vector(15 downto 0);
         cpu_wr_rd_probe : OUT  std_logic;
         cpu_cs_probe : OUT  std_logic;
         SDRAM_addr_probe : OUT  std_logic_vector(15 downto 0);
         SDRAM_wr_rd_probe : OUT  std_logic;
         ready_probe : OUT  std_logic;
         cpu_dout_probe : OUT  std_logic_vector(7 downto 0);
         sdram_dout_probe : OUT  std_logic_vector(7 downto 0);
         cpu_din_probe : OUT  std_logic_vector(7 downto 0);
         sdram_din_probe : OUT  std_logic_vector(7 downto 0);
         current_state_probe : OUT  std_logic_vector(1 downto 0);
         hit_count_probe : OUT  INTEGER;
         miss_count_probe : OUT  INTEGER
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal trigger : std_logic;
   signal cpu_addr_probe : std_logic_vector(15 downto 0);
   signal cpu_wr_rd_probe : std_logic;
   signal cpu_cs_probe : std_logic;
   signal SDRAM_addr_probe : std_logic_vector(15 downto 0);
   signal SDRAM_wr_rd_probe : std_logic;
   signal ready_probe : std_logic;
   signal cpu_dout_probe : std_logic_vector(7 downto 0);
   signal sdram_dout_probe : std_logic_vector(7 downto 0);
   signal cpu_din_probe : std_logic_vector(7 downto 0);
   signal sdram_din_probe : std_logic_vector(7 downto 0);
   signal current_state_probe : std_logic_vector(1 downto 0);
   signal hit_count_probe : INTEGER;
   signal miss_count_probe : INTEGER;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CacheSystem PORT MAP (
          clk => clk,
          reset => reset,
          trigger => trigger,
          cpu_addr_probe => cpu_addr_probe,
          cpu_wr_rd_probe => cpu_wr_rd_probe,
          cpu_cs_probe => cpu_cs_probe,
          SDRAM_addr_probe => SDRAM_addr_probe,
          SDRAM_wr_rd_probe => SDRAM_wr_rd_probe,
          ready_probe => ready_probe,
          cpu_dout_probe => cpu_dout_probe,
          sdram_dout_probe => sdram_dout_probe,
          cpu_din_probe => cpu_din_probe,
          sdram_din_probe => sdram_din_probe,
          current_state_probe => current_state_probe,
          hit_count_probe => hit_count_probe,
          miss_count_probe => miss_count_probe
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
	  wait for 50 ns;
	  reset <= '0';
	  wait for 5000 ns;
	  wait;

      -- insert stimulus here 

      wait;
   end process;

END;
