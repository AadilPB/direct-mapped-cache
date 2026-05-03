---------------------------------------------------------------------------------- 
-- 
-- Create Date:    13:39:00 10/18/2025 
-- Design Name: 	 CacheController
-- Module Name:    CacheController - Behavioral 
-- Project Name: 	 CacheController_1.1
-- Author: Aadil Bholat
-- Target Devices: Spartan3E XC3S500E
-- 
-- Description: Implements a cache controller that handles CPU read/write requests
--					 block write-backs and block allocation. Interfaces with the 
-- 				 CPU, SRAM(BlockRAM), and SDRAM controller.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL; 

-- Cache Controller: Direct-mapped cache between CPU and SDRAM
-- 16-bit address with 8-bit SRAM (cache) addressing
entity CacheController is
    Port ( 
			  -- CPU interface
			  cpu_addr : in  STD_LOGIC_VECTOR (15 downto 0); -- Address from CPU
           cpu_wr_rd : in  STD_LOGIC;							 -- CPU write/read select
           cs : in  STD_LOGIC;									 -- Chip select, enables controller
           clk : in  STD_LOGIC;									 -- System clock
			  
			  -- SDRAM (main memory) interface
           sdram_addr : out  STD_LOGIC_VECTOR (15 downto 0); -- Address sent to SDRAM
           mem_wr_rd : out  STD_LOGIC;                       -- Memory write/read select
           mem_strb : out  STD_LOGIC;								 -- Memory strobe, starts memory transfer
			  
			  -- SRAM (cache memory) interface
           wen : out  STD_LOGIC_VECTOR(0 downto 0);        -- Cache write enable  
			  sram_addr : out  STD_LOGIC_VECTOR (7 downto 0); -- Cache address (index) 
			  
			  -- Datapath control
           din_ctrl : out  STD_LOGIC;  -- Select data input source to cache
           dout_ctrl : out  STD_LOGIC; -- Select data output destination from cache
           
			  -- CPU handshake
			  rdy : out  STD_LOGIC := '0'; -- Ready signal, goes high when transaction completes
           
			  --Debug/tracking probes
			  current_state : out STD_LOGIC_VECTOR(1 downto 0);     -- FSM state output
			  hit_count : out INTEGER;									     -- Accumulating hit counter
			  miss_count : out INTEGER;                             -- Accumulating miss counter
			  dirty_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0); -- Dirty bit array 
			  valid_bit_tracker : out STD_LOGIC_VECTOR(7 downto 0)  -- Valid bit array
			  );
end CacheController;


architecture Behavioral of CacheController is

	------------------------------------
	-- CPU Address Word Organizations --
	------------------------------------
	signal tag : STD_LOGIC_VECTOR (7 downto 0);  -- Bits 15 downto 8 of cpu_addr
	signal index : STD_LOGIC_VECTOR(2 downto 0); -- Bits 7 downto 5, selects cache line
   signal offset : STD_LOGIC_VECTOR(4 downto 0); -- Bits 4 downto 0, byte within cache line


	----------------------------
	-- Cache Metadata Signals --
	----------------------------
   signal dirty_bits : STD_LOGIC_VECTOR(7 downto 0):= (others => '0'); -- Dirty bit per cache line
   signal valid_bits : STD_LOGIC_VECTOR(7 downto 0):= (others =>'0');  -- Valid bit per cache line   
   type existing_tags is array (7 downto 0) of STD_LOGIC_VECTOR(7 downto 0); 
   signal tags : existing_tags := (others => (others => '0'));         -- Stored tag per cache line
   signal counter : integer := 0;    -- Tracks the number of word transfers during allocate/writeback
   signal sdram_offset: integer := 0; -- SDRAM address offset during block transfer

	-----------------------
	-- FSM State Signals --
	-----------------------
   type state_type is (idle, compare_tag, allocate, writeback);
   signal state : state_type := idle;
	-- State ID's:
	-- idle        == 00
	-- compare_tag == 01
	-- allocate    == 10
	-- writeback   == 11
	signal state_id : STD_LOGIC_VECTOR(1 downto 0) := "00";

	--------------------------
	-- Performance Tracking --
	--------------------------
	signal misses, hits : integer := 0;

--------------------------------
-- Cache Controller Behaviour --
--------------------------------
begin
process(clk)
    begin
        if clk'Event and clk='1' then            
	
				case state is
					 --------------------------------------------------
					 -- IDLE STATE: Wait for a valid CPU instruction --
					 --------------------------------------------------
                when idle =>
						  --CPU Address Decomposition
						  tag <= cpu_addr(15 downto 8);
						  index <= cpu_addr(7 downto 5);
						  offset <= cpu_addr(4 downto 0); 
                    --reset all communications signals
                    rdy <= '1'; -- Signal CPU that controller is ready for a new request
						  mem_wr_rd <= '0';
						  wen <= "0";
						  din_ctrl <= '0';
						  dout_ctrl <= '0';
						  mem_strb <= '0';
						  
						  --Wait for CPU request
                    if cs = '1' then
                        state <= compare_tag;
								state_id <= "01";
                    else
                        state <= idle;
								state_id <= "00";
                    end if;
                
					 ------------------------------------------------------
					 -- COMPARE TAG STATE: Check for a cache hit or miss --
					 -- and perform the required operations				  --
					 ------------------------------------------------------    
                when compare_tag =>
						  rdy <= '0'; 
						  --Hit if line is valid and stored tag matches requested tag
                    if valid_bits(to_integer(unsigned(index))) = '1' and tags(to_integer(unsigned(index))) = tag then 
                        --HIT CASE
								hits <= hits + 1;
								sram_addr <= index & offset;
								--WRITE HIT
                        if cpu_wr_rd = '1' then    
                            wen <= "1";
									 dout_ctrl <= '0';
                            din_ctrl <= '0';
                            dirty_bits(to_integer(unsigned(index))) <='1';
                            valid_bits(to_integer(unsigned(index))) <='1';
                            tags(to_integer(unsigned(index))) <= tag;
                            
                        --READ HIT
                        elsif cpu_wr_rd = '0' then    
                            wen <= "0";
									 din_ctrl <= '0';
									 dout_ctrl <= '1';
                            
                        end if;
								
								state <= idle;
								state_id <= "00";
						  
                    else
								--MISS CASE
								misses <= misses + 1;
                        if dirty_bits(to_integer(unsigned(index)))= '0' then
                            --Fetch new block from SDRAM
                            state <= allocate;
									 state_id <= "10";

                        elsif dirty_bits(to_integer(unsigned(index))) = '1' then
                            --Writeback dirty block back to SDRAM
									 state <= writeback;
									 state_id <= "11";
                        end if;
                    end if;
                ----------------------------------------------------------------------    
                -- ALLOCATE STATE: Fetch a new block from SDRAM and store into SRAM --
					 ----------------------------------------------------------------------
                when allocate =>
                    din_ctrl <= '1';
                    dout_ctrl <= '0';
                    
                    if counter = 64 then
                        -- 32 words x 2 cycles each (64 cycles total) to transfer full cache line 
								counter <= 0;
                        sdram_offset <= 0;
                        valid_bits(to_integer(unsigned(index))) <= '1';
                        tags(to_integer(unsigned(index))) <= tag; 
                        state <= compare_tag;
								state_id <= "01";
                    
                    else
                        if counter mod 2 = 0 then
                            -- Pause every even cycle
									 mem_strb <= '0';
                        else
									 -- Read from SDRAM into SRAM every odd cycle
                            sdram_addr <= tag & index & STD_LOGIC_VECTOR(to_unsigned(sdram_offset, 5));
                            sram_addr <= index & STD_LOGIC_VECTOR(to_unsigned(sdram_offset, 5));
                            wen <= "1";
									 mem_wr_rd <= '0';
                            mem_strb <= '1';
                            sdram_offset <= sdram_offset +1;
                        end if;
                        counter <= counter + 1;
                    end if;
                
					 ------------------------------------------------------------------    
                -- WRITEBACK STATE: Write Dirty block from SRAM back into SDRAM --
					 ------------------------------------------------------------------				 
                when writeback =>
                    din_ctrl <= '0';
                    dout_ctrl <= '0';
                    
                    if counter = 64 then
                        -- 32 words x 2 cycles each (64 cycles total) to writeback,
								-- then move to allocate for a new fetch
								counter <= 0;
                        sdram_offset <= 0;
                        dirty_bits(to_integer(unsigned(index))) <= '0';
                        state <= allocate;
								state_id <= "10";
                        
                    else
                        if counter mod 2 = 0 then
									 -- Pause every even cycle
                            mem_strb <= '0';
                        else
									 -- Write current SRAM word to SDRAM every odd cycle
                            sdram_addr <= tags(to_integer(unsigned(index))) & index & STD_LOGIC_VECTOR(to_unsigned(sdram_offset,5));
                            sram_addr <= index & STD_LOGIC_VECTOR(to_unsigned(sdram_offset, 5));
                            mem_wr_rd <= '1';
									 wen <= "0";
                            mem_strb <= '1';
                            sdram_offset <= sdram_offset + 1;
                        end if;
								counter <= counter + 1;
                    end if;
                
					 -------------------   
                -- DEFAULT STATE --
					 -------------------
                when others =>
                    state <= idle;
						  state_id <= "00"; 
                end case;

            
        end if;
            
    end process;
	 
		-------------------------   
      -- Set tracking probes --
		-------------------------
		current_state <= state_id;
		hit_count <= hits;
		miss_count <= misses;
		dirty_bit_tracker <= dirty_bits;
		valid_bit_tracker <= valid_bits;
	 
end Behavioral;
