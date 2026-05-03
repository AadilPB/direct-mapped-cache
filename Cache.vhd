----------------------------------------------------------------------------------
--
-- Create Date:    15:50:03 10/18/2025 
-- Design Name: 	 Cache
-- Module Name:    Cache - Behavioral 
-- Project Name: 	 Cache
 
-- Author: Aadil Bholat
-- Target Devices: Spartan3E XC3S500E
-- 
-- Description: Implements the whole cache, which includes the Cache Controller
--					 and SRAM(BlockRAM). This module connects the Cache Controller
--					 to the SRAM, including the multiplexer and demultiplexers
--					 controlling the input and output of the SRAM.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Cache: Combines SRAM and CacheController components, manages data between CPU and SDRAM
entity Cache is
    Port ( clk : in STD_LOGIC; 										 -- System clock
			  cpu_addr : in  STD_LOGIC_VECTOR (15 downto 0);	 -- Address from CPU
           cpu_wr_rd : in  STD_LOGIC;								 -- CPU write/read select
           cs : in  STD_LOGIC;										 -- Chip select, enables cache
           cpu_dout : in  STD_LOGIC_VECTOR (7 downto 0);		 -- Data from CPU (for writes)
           sdram_dout : in  STD_LOGIC_VECTOR (7 downto 0);   -- Data from SDRAM (for allocation)
           sdram_din : out  STD_LOGIC_VECTOR (7 downto 0);	 -- Data to SDRAM (for writeback)
           cpu_din : out  STD_LOGIC_VECTOR (7 downto 0);		 -- Data to CPU (for reads)
           sdram_addr : out  STD_LOGIC_VECTOR (15 downto 0); -- Address forwarded to SDRAM
           mem_wr_rd : out  STD_LOGIC;								 -- Memory write/read select
           mem_strb : out  STD_LOGIC;								 -- Memory strobe, starts transfer
			  rdy : out STD_LOGIC;										 -- Ready signal
			  
			  --Tracking probes
			  current_state : out STD_LOGIC_VECTOR(1 downto 0); 	  -- Cache controller state 
			  hit_count : out INTEGER;										  -- Accumulating hit counter
			  miss_count : out INTEGER;									  -- Accumulating miss counter
			  wen_tracker : out STD_LOGIC_VECTOR(0 downto 0);       -- Write enable tracker
			  dirty_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0); -- Dirty bit array tracker
			  valid_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0); -- Valid bit array tracker
			  din_ctrl_tracker : out STD_LOGIC;							  -- Data in control tracker
			  dout_ctrl_tracker : out STD_LOGIC							  -- Data out control tracker
			  );
end Cache;

architecture Behavioral of Cache is
	---------------------------------------
	-- SRAM(BRAM) component and signals  --
	---------------------------------------
	COMPONENT SRAM
		PORT (
			 clka : IN STD_LOGIC;
			 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
			 addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			 douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
		  );
	END COMPONENT;
	
	signal sram_addr_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	signal sram_wen : STD_LOGIC_VECTOR(0 downto 0):= (others => '0'); 
	signal sram_din : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
	signal sram_dout : STD_LOGIC_VECTOR(7 downto 0):= (others => '0');
	
	--------------------------------------------
	-- Cache Controller component and signals --
	--------------------------------------------
	COMPONENT CacheController is
		 Port ( cpu_addr : in  STD_LOGIC_VECTOR (15 downto 0);
				  cpu_wr_rd : in  STD_LOGIC;
				  cs : in  STD_LOGIC;
				  clk : in  STD_LOGIC;
				  sdram_addr : out  STD_LOGIC_VECTOR (15 downto 0);
				  mem_wr_rd : out  STD_LOGIC;
				  mem_strb : out  STD_LOGIC;
				  wen : out  STD_LOGIC_VECTOR(0 downto 0);
				  din_ctrl : out  STD_LOGIC;
				  dout_ctrl : out  STD_LOGIC;
				  rdy : out  STD_LOGIC;
				  sram_addr : out  STD_LOGIC_VECTOR (7 downto 0);
				  -- Tracking probes
				  current_state : out STD_LOGIC_VECTOR(1 downto 0);
				  hit_count : out INTEGER;
			     miss_count : out INTEGER;
				  dirty_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0);
				  valid_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0)
				  );
	end COMPONENT;
	
	signal din_ctrl_out : STD_LOGIC := '0';
	signal dout_ctrl_out : STD_LOGIC := '0';

begin
	---------------------
	-- Cache Structure --
	---------------------
	SRAM_Component : SRAM
   PORT MAP (
		clka => clk,
		wea => sram_wen,
		addra => sram_addr_in,
		dina => sram_din,
		douta => sram_dout
	);
	
	CacheControllerComponent : CacheController
	PORT MAP (
		cpu_addr => cpu_addr,
		cpu_wr_rd => cpu_wr_rd,
		cs => cs,
		clk => clk, 
		sdram_addr => sdram_addr, 
		mem_wr_rd => mem_wr_rd,
		mem_strb => mem_strb,
		wen => sram_wen,
		din_ctrl => din_ctrl_out,
		dout_ctrl => dout_ctrl_out,
		rdy => rdy,
		sram_addr => sram_addr_in,
		-- Tracking probes
		current_state => current_state,
		hit_count => hit_count,
	   miss_count => miss_count,
		dirty_bit_tracker => dirty_bit_tracker,
		valid_bit_tracker => valid_bit_tracker
	);
	
	---------------------
	-- Cache Behaviour --
	---------------------
	-- Route data to/from SRAM based on controller signals
	process(clk)
	begin
		if rising_edge(clk) then
			--Write data into SRAM
			if din_ctrl_out = '1' then
				--SDRAM source
				sram_din <= sdram_dout;
			else
				--CPU source
				sram_din <= cpu_dout;
			end if;
	
			--Read data from SRAM
			if dout_ctrl_out = '1' then
				--CPU receiver
				cpu_din <= sram_dout;
			else
				--SDRAM receiver
				sdram_din <= sram_dout;
				
			end if;
		end if;
	end process;
	
	---------------------
	-- Tracking probes --
	---------------------
	wen_tracker <= sram_wen;
	din_ctrl_tracker <= din_ctrl_out;
	dout_ctrl_tracker <= dout_ctrl_out;

end Behavioral;

