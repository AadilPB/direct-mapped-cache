----------------------------------------------------------------------------------
-- Create Date:    13:45:55 10/18/2025 
-- Design Name:	 SDRAMController 
-- Module Name:    SDRAMController - Behavioral 
-- Project Name:   SDRAMCONTROLLER
--
-- Target Devices: Spartan3E XC3S500E
-- 
-- Description: Implements an SDRAM Controller that interfaces 
--					 with the Cache Controller and the SRAM(BlockRAM).
-- 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL; 

-- SDRAM Controller: Simulated 8x32 byte SDRAM interfacing with cache
entity SDRAMController is
    Port ( clk : in  STD_LOGIC;								 -- System clock
           addr : in  STD_LOGIC_VECTOR (15 downto 0);  -- Memory address (bits 7:5 = row, 4:0 = col)
           wr_rd : in  STD_LOGIC;							 -- Write/read select (1=write, 0=read)
           mem_strb : in  STD_LOGIC;						 -- Strobe to initiate memory access
           din : in  STD_LOGIC_VECTOR (7 downto 0);	 -- Data input for writes
           dout : out  STD_LOGIC_VECTOR (7 downto 0)); -- Data output for reads
end SDRAMController;

architecture Behavioral of SDRAMController is

-------------------------
-- Memory Organization --
-------------------------
-- 8 rows x 32 words with each word 8 bits wide
Type SDRAM_mem is array (7 downto 0, 31 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal SDRAM : SDRAM_mem; 
signal counter: integer := 0;

--------------------------------
-- SDRAM Controller Behaviour --
--------------------------------
begin
process(clk)
    begin
        if clk'Event and clk='1' then    
            -- Initialize each address with its index value (i*32 + j)  
				if counter = 0 then
                for i in 0 to 7 loop
                    for j in 0 to 31 loop
                        SDRAM(i, j) <= std_logic_vector(to_unsigned(i*32 + j, 8));
                    end loop;
                end loop;
                counter <= 1;
            end if;
            -- Handle memory access
            if mem_strb = '1' then
                if wr_rd = '1' then
						  --Write to SDRAM
                    SDRAM(to_integer(unsigned(addr(7 downto 5))), to_integer(unsigned(addr(4 downto 0)))) <= DIN;
                else
						  --Read from SDRAM
                    dout <= SDRAM(to_integer(unsigned(addr(7 downto 5))), to_integer(unsigned(addr(4 downto 0))));
                end if;
            end if;
        end if;
    end process;

end Behavioral;


