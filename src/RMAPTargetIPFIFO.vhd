------------------------------------------------------------------------------
-- The MIT License (MIT)
--
-- Copyright (c) <2018> Konovalov Vitaliy
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;

entity RMAPTargetIPFIFO is 
	generic (
		DATA_WIDTH : integer := 9;
		ADDR_WIDTH : integer := 4 
	);
	port (
		clk        : in  std_logic                                      ;
		rst        : in  std_logic                                      ;
		-- write interface
		dataIn     : in  std_logic_vector(DATA_WIDTH-1 downto 0)        ;
		wrEnable   : in  std_logic                                      ;
		full       : out std_logic                                      ;
		-- read interface
		dataOut    : out std_logic_vector(DATA_WIDTH-1 downto 0)        ;
		rdEnable   : in  std_logic                                      ;
		empty      : out std_logic                                      ;
		-- empty space counter
		statusCntr : out std_logic_vector(ADDR_WIDTH-1 downto 0)         
	);
end RMAPTargetIPFIFO;

architecture behavioral of RMAPTargetIPFIFO is
    
	constant RAM_DEPTH : integer := 2**ADDR_WIDTH;

	signal wr_pointer : integer range 0 to RAM_DEPTH-1;
	signal rd_pointer : integer range 0 to RAM_DEPTH-1;

	signal statusCntrReg : integer range 0 to RAM_DEPTH;
	signal statusCntrNxt : integer range 0 to RAM_DEPTH;

	signal iFull  : std_logic;
	signal iEmpty : std_logic;

	type memory_t is array (0 to RAM_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : memory_t;

begin

	statusCntr <= std_logic_vector(to_unsigned(statusCntrReg, statusCntr'length));
	iEmpty <= '1' when statusCntrReg = RAM_DEPTH else '0';
	empty <= iEmpty;
	full <= iFull;

	process (clk) begin
		dataOut <= mem(rd_pointer) when (rdEnable and not iEmpty); 
		mem(wr_pointer) <= dataIn when (wrEnable and not iFull); 
	end process;

	process (rst, clk) begin
		if(rst = '1') then
			iFull <= '0';
			wr_pointer <= 0;
			rd_pointer <= 0;
			statusCntrReg <= RAM_DEPTH; 
		elsif(rising_edge(clk)) then
			iFull <= '1' when statusCntrNxt = 0 else '0';
			wr_pointer <= wr_pointer + 1 when (wrEnable and not iFull);
			rd_pointer <= rd_pointer + 1 when (rdEnable and not iEmpty);
			statusCntrReg <= statusCntrNxt;
		end if;
	end process;

	process (rdEnable, wrEnable, iFull, iEmpty) begin
		if((rdEnable and not iEmpty) and not(wrEnable and not iFull)) then
			statusCntrNxt <= statusCntrReg + 1; -- Read but not write
		elsif(not(rdEnable and not iEmpty) and (wrEnable and not iFull)) then 
			statusCntrNxt <= statusCntrReg - 1; -- Write but not read
		else 
			statusCntrNxt <= statusCntrReg; -- other cases
		end if;
	end process;

end behavioral;