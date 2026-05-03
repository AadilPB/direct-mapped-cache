----------------------------------------------------------------------------------
--
-- Create Date:    15:11:25 10/18/2025 
-- Design Name: 	 CacheSystem
-- Module Name:    CacheSystem - Behavioral 
-- Project Name: 	 CacheSystem
-- Author: Aadil Bholat
-- Target Devices: Spartan3E XC3S500E
-- 
-- Description: Implements the Cache system, combining the Cache, CPU and
--					 SDRAMController.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Cache System: Top-level integration of CPU, Cache, and SDRAM components
entity CacheSystem is
    Port ( clk : in  STD_LOGIC;     -- System clock
           reset : in  STD_LOGIC;   -- System reset
			  trigger : out STD_LOGIC; -- CPU trigger pulse output
			  
			  -- Probe ports
			  cpu_addr_probe : out STD_LOGIC_VECTOR(15 downto 0);      
			  cpu_wr_rd_probe : out STD_LOGIC;							    
			  cpu_cs_probe : out STD_LOGIC;								    
			  SDRAM_addr_probe : out STD_LOGIC_VECTOR(15 downto 0);   
			  SDRAM_wr_rd_probe : out STD_LOGIC;						    
			  ready_probe : out STD_LOGIC;								    
			  cpu_dout_probe : out STD_LOGIC_VECTOR(7 downto 0);	    
			  sdram_dout_probe : out STD_LOGIC_VECTOR(7 downto 0);    
			  cpu_din_probe : out STD_LOGIC_VECTOR(7 downto 0);	    
			  sdram_din_probe : out STD_LOGIC_VECTOR(7 downto 0);	    
			  current_state_probe : out STD_LOGIC_VECTOR(1 downto 0); 
			  hit_count_probe : out INTEGER;									 
			  miss_count_probe : out INTEGER;								 
			  wen_probe : out STD_LOGIC_VECTOR(0 downto 0);				 
			  dirty_bit_probe : out STD_LOGIC_VECTOR(7 downto 0);		 
			  valid_bit_probe : out STD_LOGIC_VECTOR(7 downto 0);		 
			  din_ctrl_probe : out STD_LOGIC;								 
			  dout_ctrl_probe : out STD_LOGIC								 
			  );
end CacheSystem;

architecture Behavioral of CacheSystem is

	-----------------------------------------	
	-- Cache System Components and signals --	
	-----------------------------------------	
	COMPONENT Cache
	PORT(
		clk : in STD_LOGIC; 
		cpu_addr : in  STD_LOGIC_VECTOR (15 downto 0);
      cpu_wr_rd : in  STD_LOGIC;
      cs : in  STD_LOGIC;
      cpu_dout : in  STD_LOGIC_VECTOR (7 downto 0);
      sdram_dout : in  STD_LOGIC_VECTOR (7 downto 0);
      sdram_din : out  STD_LOGIC_VECTOR (7 downto 0);
      cpu_din : out  STD_LOGIC_VECTOR (7 downto 0);
      sdram_addr : out  STD_LOGIC_VECTOR (15 downto 0);
      mem_wr_rd : out  STD_LOGIC;
      mem_strb : out  STD_LOGIC;
		rdy : out STD_LOGIC;
		
		-- Tracking probes
		current_state : out STD_LOGIC_VECTOR(1 downto 0);
		hit_count : out INTEGER;
		miss_count : out INTEGER;
		wen_tracker : out STD_LOGIC_VECTOR(0 downto 0);
		dirty_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0);
		valid_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0);
		din_ctrl_tracker : out STD_LOGIC;
		dout_ctrl_tracker : out STD_LOGIC
	);
	end COMPONENT;
	
	COMPONENT CPU_Gen
	PORT(
		clk 		: in  STD_LOGIC;
      rst 		: in  STD_LOGIC;
      trig 		: in  STD_LOGIC;
		-- Interface to the Cache Controller.
      Address 	: out  STD_LOGIC_VECTOR (15 downto 0);
      wr_rd 	: out  STD_LOGIC;
      cs 		: out  STD_LOGIC;
      DOut 		: out  STD_LOGIC_VECTOR (7 downto 0)
	);
	end COMPONENT;
	
	COMPONENT SDRAMController
	PORT(
			  clk : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (15 downto 0);
           wr_rd : in  STD_LOGIC;
           mem_strb : in  STD_LOGIC;
           din : in  STD_LOGIC_VECTOR (7 downto 0);
           dout : out  STD_LOGIC_VECTOR (7 downto 0)
	);
	end COMPONENT;
	
	-- Internal interconnecting signals
	signal cpu_addr_to_cache, sdram_addr_from_cache : STD_LOGIC_VECTOR(15 downto 0);
	signal cpu_wr_rd_to_cache, sdram_wr_rd_from_cache : STD_LOGIC; 
	signal cpu_cs : STD_LOGIC;
	signal sdram_mem_strb : STD_LOGIC;
	signal cpu_dout_to_cache, sdram_dout_to_cache : STD_LOGIC_VECTOR(7 downto 0);
	signal cpu_din_from_cache, sdram_din_from_cache : STD_LOGIC_VECTOR(7 downto 0); 
	signal cpu_rdy_from_cache : STD_LOGIC; 
	signal internal_trig : STD_LOGIC := '0';
	signal pulse : integer := 0;
	signal current_state_sgnl : STD_LOGIC_VECTOR(1 downto 0) := "00"; 
	signal hit_count_sgnl : INTEGER := 0;
	signal miss_count_sgnl : INTEGER := 0;
	signal wen_sgnl : STD_LOGIC_VECTOR(0 downto 0);
	signal dirty_bit_sgnl : STD_LOGIC_VECTOR(7 downto 0);
	signal valid_bit_sgnl : STD_LOGIC_VECTOR(7 downto 0);
	signal din_ctrl_sgnl	 : STD_LOGIC;
	signal dout_ctrl_sgnl : STD_LOGIC;
	
	--------------------------------------	
	-- Chipscope Components and Signals --
	--------------------------------------
	component icon
	  PORT (
		 CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		 CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));
	end component;
	
	component ila
		PORT (
		 CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		 CLK : IN STD_LOGIC;
		 DATA : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
		 TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component vio
		PORT (
		 CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		 ASYNC_OUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

end component;
	
	signal control0 : STD_LOGIC_VECTOR(35 downto 0);
	signal control1 : STD_LOGIC_VECTOR(35 downto 0);
	signal ila_data : STD_LOGIC_VECTOR(127 downto 0);
	signal trig0 : STD_LOGIC_VECTOR(7 downto 0);
	signal vio_out : STD_LOGIC_VECTOR(31 downto 0);
	
begin
	-------------------------
	-- Chipscope Port Maps --
	-------------------------
	sys_icon : icon
	  port map (
		 CONTROL0 => control0,
		 CONTROL1 => control1
		 );
	
	sys_ila : ila
		port map (
		CONTROL => control0,
		CLK => clk,
		DATA => ila_data,
		TRIG0 => trig0
		);
	 
	sys_vio : vio
		port map (
       CONTROL => control1,
       ASYNC_OUT => vio_out
	 );
	 
	----------------------------
	-- Cache System Port Maps --
	----------------------------
	CPU : CPU_Gen
		port map (
		clk => clk,		
      rst => reset,
      trig => internal_trig,		
		-- Interface to the Cache Controller.
      Address => cpu_addr_to_cache,	
      wr_rd => cpu_wr_rd_to_cache,	
      cs => cpu_cs,		
      DOut => cpu_dout_to_cache		
		);
		
	SDRAM : SDRAMController
		port map (
			  clk => clk,
           addr => sdram_addr_from_cache,
           wr_rd => sdram_wr_rd_from_cache,
           mem_strb => sdram_mem_strb,
           din => sdram_din_from_cache,
           dout => sdram_dout_to_cache
			  );
			  
	FullCache : Cache
		port map (
			clk => clk, 
			cpu_addr => cpu_addr_to_cache, 
			cpu_wr_rd => cpu_wr_rd_to_cache,
			cs => cpu_cs,
			cpu_dout => cpu_dout_to_cache,
			sdram_dout => sdram_dout_to_cache,
			sdram_din => sdram_din_from_cache,
			cpu_din => cpu_din_from_cache,
			sdram_addr => sdram_addr_from_cache,
			mem_wr_rd => sdram_wr_rd_from_cache,
			mem_strb => sdram_mem_strb,
			rdy => cpu_rdy_from_cache,
			
			-- Tracking probes
			current_state => current_state_sgnl,
			hit_count => hit_count_sgnl,
			miss_count => miss_count_sgnl,
			wen_tracker => wen_sgnl,
			dirty_bit_tracker => dirty_bit_sgnl,
			valid_bit_tracker => valid_bit_sgnl,
			din_ctrl_tracker => din_ctrl_sgnl,
			dout_ctrl_tracker => dout_ctrl_sgnl
		);
		
		-- Generate a single cycle trigger pulse to CPU every time cache signals ready
		-- Two cycle delay to prevent back-to-back requests
		process(clk)
		begin
			 if rising_edge(clk) then
				  if cpu_rdy_from_cache = '1' then
						
						pulse <= pulse + 1;
						if pulse = 1 then
						internal_trig <= '1';
							 pulse <= 0;
						else
							internal_trig <= '0';
						end if;
				  else
						internal_trig <= '0';  
						pulse <= 0;
				  end if;
			 end if;
		end process;

	-- Set tracking probes
	cpu_addr_probe <= cpu_addr_to_cache;
	cpu_wr_rd_probe <= cpu_wr_rd_to_cache;
	cpu_cs_probe <= cpu_cs;
			
	SDRAM_addr_probe <= sdram_addr_from_cache;
	SDRAM_wr_rd_probe <= sdram_wr_rd_from_cache;
			
	ready_probe <= cpu_rdy_from_cache;
			
	cpu_dout_probe <= cpu_dout_to_cache;
	sdram_dout_probe <= sdram_dout_to_cache;
			
	cpu_din_probe <= cpu_din_from_cache;
	sdram_din_probe <= sdram_din_from_cache;
	trigger <= internal_trig;
			
	current_state_probe <= current_state_sgnl;
	hit_count_probe <= hit_count_sgnl;
	miss_count_probe <= miss_count_sgnl;
			
	wen_probe <= wen_sgnl;
			
	dirty_bit_probe <= dirty_bit_sgnl;
	valid_bit_probe <= valid_bit_sgnl;
	din_ctrl_probe <= din_ctrl_sgnl;
	dout_ctrl_probe <= dout_ctrl_sgnl;
			
			
	-- Map internal signals to ILA data bus for ChipScope monitoring
	ila_data(15 downto 0) <= cpu_addr_to_cache;
	ila_data(16) <= cpu_wr_rd_to_cache;
	ila_data(17) <= cpu_cs;
			
	ila_data(33 downto 18) <= sdram_addr_from_cache;
	ila_data(34) <= sdram_wr_rd_from_cache;
			
	ila_data(35) <= cpu_rdy_from_cache;
			
	ila_data(43 downto 36) <= cpu_dout_to_cache;
	ila_data(51 downto 44) <= sdram_dout_to_cache;
			
	ila_data(59 downto 52) <= cpu_din_from_cache;
	ila_data(67 downto 60) <= sdram_din_from_cache; 
			
	ila_data(68) <= internal_trig;
			
	ila_data(70 downto 69) <= current_state_sgnl;
			
	ila_data(86 downto 71) <= std_logic_vector(to_unsigned(hit_count_sgnl, 16));
	ila_data(102 downto 87) <= std_logic_vector(to_unsigned(miss_count_sgnl, 16));
			
			
	ila_data(103) <= clk;
	ila_data(104 downto 104) <= wen_sgnl;
	ila_data(112 downto 105) <= dirty_bit_sgnl;
	ila_data(120 downto 113) <= valid_bit_sgnl;
	ila_data(121) <= din_ctrl_sgnl;
	ila_data(122) <= dout_ctrl_sgnl;
			
end Behavioral;

