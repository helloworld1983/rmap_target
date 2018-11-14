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
		dataOut    : out std_logic_vec
		tor(DATA_WIDTH-1 downto 0)        ;
		rdEnable   : in  std_logic                                      ;
		empty      : out std_logic                                      ;
		-- empty space counter
		statusCntr : out std_logic_vector(ADDR_WIDTH-1 downto 0)         
	);
end RMAPTargetIPFIFO;

architecture behavioral of RMAPTargetIPFIFO is
    
	constant RAM_DEPTH : integer := ; -- to do

	signal wr_pointer : std_logic_vector(ADDR_WIDTH-1 downto 0);
	signal rd_pointer : std_logic_vector(ADDR_WIDTH-1 downto 0);

	signal statusCntrReg : std_logic_vector(ADDR_WIDTH downto 0);
	signal statusCntrNxt : std_logic_vector(ADDR_WIDTH downto 0);

	type memory_t is array (0 to RAM_DEPTH-1) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem : memory_t;

begin

	statusCntr <= statusCntrReg(ADDR_WIDTH-1 downto 0);
	empty <= statusCntrReg(ADDR_WIDTH);

	process (clk) begin
		dataOut <= mem(rd_pointer) when (rdEnable and not empty); 
		mem(wr_pointer) <= dataIn when (wrEnable and not full); 
	end process;

	process (rst, clk) begin
		if(rst = '1') then
			full <= '0';
			wr_pointer <= (others => '0');
			rd_pointer <= (others => '0');
			statusCntrReg <= RAM_DEPTH; -- to do
		elsif(rising_edge(clk)) then
			full <= '1' when statusCntrNxt = (statusCntrNxt'range => '0') else '0';
			wr_pointer <= wr_pointer + 1 when (wrEnable and not full);
			rd_pointer <= rd_pointer + 1 when (rdEnable and not empty);
			statusCntrReg <= statusCntrNxt;
		end if;
	end process;

	process (rdEnable, wrEnable, full, empty) begin
		if((rdEnable and not empty) and not(wrEnable and not full)) then
			statusCntrNxt <= statusCntrReg + 1; -- Read but not write
		elsif(not(rdEnable and not empty) and (wrEnable and not full)) then 
			statusCntrNxt <= statusCntrReg - 1; -- Write but not read
		else 
			statusCntrNxt <= statusCntrReg; -- other cases
		end if;
	end process;

end behavioral;