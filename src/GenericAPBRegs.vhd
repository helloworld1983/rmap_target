------------------------------------------------------------------------------
-- The MIT License (MIT)
--
-- Copyright (c) <2018> <Vitaliy Konovalov>
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.amba.all;

entity GenericAPBRegs is 
	generic (
		-- apb generics
		PINDEX   : integer := 0      ;
		PADDR    : integer := 0      ;
		PMASK    : integer := 16#fff#;
		PIRQ     : integer := 0      ;
		-- regs generics
		REGSNUM  : integer := 1      ;
		-- leon config generics
		VENDOR   : integer := 16#ff# ;
		DEVICE   : integer := 16#ff# ;
		REVISION : integer := 0       
	);
	port (
		rst  : in  std_ulogic                                     ;
		clk  : in  std_ulogic                                     ;
		-- APB interface
		apbi : in  apb_slv_in_type                                ;
		apbo : out apb_slv_out_type                               ;
		-- registers
		regrst : in  std_logic_vector (REGSNUM*32-1 downto 0)     ;
		regi   : in  std_logic_vector (REGSNUM*32-1 downto 0)     ;
		rego   : out std_logic_vector (REGSNUM*32-1 downto 0)         
	);
end;

architecture behavioral of GenericAPBRegs is

	constant PCONFIG : apb_config_type := (
	  0 => ahb_device_reg ( VENDOR, DEVICE, 0, REVISION, PIRQ),
	  1 => apb_iobar(PADDR, PMASK));

	signal regs    : std_logic_vector(REGSNUM*32-1 downto 0);
	signal regAddr : integer;
	signal apbAccess : std_logic;

begin 

	regAddr <= to_integer(unsigned(apbi.paddr(31 downto 2)));
	rego <= regs;
	apbAccess <= apbi.psel(PINDEX) and apbi.penable;
	
	-- write to registers
	process (rst, clk) begin
		if (rst = '1') then
			regs <= regrst;
		elsif (rising_edge(clk)) then
			if(apbAccess = '1' and apbi.pwrite = '1') then
				regs(regAddr*32+31 downto regAddr*32) <= apbi.pwdata;
			end if;
		end if;
	end process;

	-- read from registers
	apbo.prdata <= regi(regAddr*32+31 downto regAddr*32) when (apbAccess = '1' and apbi.pwrite = '0') else (others => '0');

end behavioral;