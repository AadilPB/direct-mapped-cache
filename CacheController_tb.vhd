--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:25:32 10/18/2025
-- Design Name:   
-- Module Name:   /home/student1/a2bholat/coe758/CacheController_1.1/CacheController_tb.vhd
-- Project Name:  CacheController_1.1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CacheController
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
 
ENTITY CacheController_tb IS
END CacheController_tb;
 
ARCHITECTURE behavior OF CacheController_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CacheController
    PORT(
         cpu_addr : IN  std_logic_vector(15 downto 0);
         cpu_wr_rd : IN  std_logic;
         cs : IN  std_logic;
         clk : IN  std_logic;
         sdram_addr : OUT  std_logic_vector(15 downto 0);
         mem_wr_rd : OUT  std_logic;
         mem_strb : OUT  std_logic;
         wen : OUT  std_logic_vector(0 downto 0);
         din_ctrl : OUT  std_logic;
         dout_ctrl : OUT  std_logic;
         rdy : OUT  std_logic;
         sram_addr : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal cpu_addr : std_logic_vector(15 downto 0) := (others => '0');
   signal cpu_wr_rd : std_logic := '0';
   signal cs : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal sdram_addr : std_logic_vector(15 downto 0);
   signal mem_wr_rd : std_logic;
   signal mem_strb : std_logic;
   signal wen : std_logic_vector(0 downto 0);
   signal din_ctrl : std_logic;
   signal dout_ctrl : std_logic;
   signal rdy : std_logic;
   signal sram_addr : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CacheController PORT MAP (
          cpu_addr => cpu_addr,
          cpu_wr_rd => cpu_wr_rd,
          cs => cs,
          clk => clk,
          sdram_addr => sdram_addr,
          mem_wr_rd => mem_wr_rd,
          mem_strb => mem_strb,
          wen => wen,
          din_ctrl => din_ctrl,
          dout_ctrl => dout_ctrl,
          rdy => rdy,
          sram_addr => sram_addr
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
		report "----- Begin Simulation Report -----";
	
      -- IDLE
      wait for 100 ns;	

      wait for clk_period*10;
		
		--CLEAN MISS
		report "----- READ MISS TEST ----";
		cs <= '1';
		cpu_addr <= x"0100";
		cpu_wr_rd <= '0';
		wait for clk_period*150; 
		report "Clean miss completed, valid and tag values now set";
		
		--READ HIT
		report "----- READ HIT TEST -----";
		cpu_addr <= x"0100";
		wait for clk_period*10;
		report "Read hit output: rdy =" & std_logic'image(rdy) & " dout_ctrl =" & std_logic'image(dout_ctrl);
      
		--WRITE HIT
		report "----- WRITE HIT TEST -----";
		cpu_addr <= x"0100";
		cpu_wr_rd <= '1';
		wait for clk_period*10;
		
		report "Write hit output: rdy=" & std_logic'image(rdy) & " din_ctrl=" & std_logic'image(din_ctrl);
		
		--DIRTY MISS
		report "----- DIRTY MIS TEST -----";
		cpu_addr <= x"8100"; 
		cpu_wr_rd <= '0';
		wait for clk_period*300;
		
		report "Dirty miss output: " & "mem_strb =" & std_logic'image(mem_strb) & " mem_wr_rd=" & std_logic'image(mem_wr_rd)
		& " din_ctrl =" & std_logic'image(din_ctrl) & " dout_ctrl=" & std_logic'image(dout_ctrl); 
		
		wait for clk_period*20;
		report "----- Simulation Complete -----";
		
      wait;
   end process;

END;
