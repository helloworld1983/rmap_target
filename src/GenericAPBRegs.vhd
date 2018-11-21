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

---- to RMAPTargetIPDecoder
--rmapLogicalAddress   : in  std_logic_vetor ( 7 downto 0)        ;
--rmapCommand          : in  std_logic_vetor ( 3 downto 0)        ;
--rmapKey              : in  std_logic_vetor ( 7 downto 0)        ;
--rmapExtendedAddress  : in  std_logic_vetor ( 7 downto 0)        ;
--rmapAddress          : in  std_logic_vetor (31 downto 0)        ;
--rmapDataLength       : in  std_logic_vetor (23 downto 0)        ;
--requestAuthorization : in  std_logic                            ;
--authorizeAck         : out std_logic                            ;
--rejectAck            : out std_logic                            ;
--replyStatus          : out std_logic_vetor ( 7 downto 0)        ;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library grlib;
use grlib.config_types.all;
use grlib.config.all;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

entity GenricAPBRegs is 
	generic (
		-- apb generics
		PINDEX   : integer := 0      ;
		PADDR    : integer := 0      ;
		PMASK    : integer := 16#fff#;
		PIRQ     : integer := 0      ;
		-- regs generics
		REGSNUM  : integer := 1      ;
		REGSRST  : std_logic_vetor(REGSNUM*32-1 downto 0) := (others => '0');
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
		regi : in  std_logic_vetor (REGSNUM*32-1 downto 0)        ;
		rego : out std_logic_vetor (REGSNUM*32-1 downto 0)         
	);
end;

architecture behavioral of GenricAPBRegs is

	constant PCONFIG : apb_config_type := (
	  0 => ahb_device_reg ( VENDOR, DEVICE, 0, REVISION, PIRQ),
	  1 => apb_iobar(PADDR, PMASK));

	signal regs    : std_logic_vetor(REGSNUM*32-1 downto 0);
	signal regAddr : integer;

begin 

	regAddr <= to_integer(unsigned(apbi.paddr(31 downto 2), 29));
	rego <= regs;

	-- write to registers
	process (reset, clock) begin
		if (reset = '1') then
			regs <= REGSRST;
		elsif (rising_edge(clock)) then
			if(apbi.psel(PINDEX) and apbi.penable and apbi.pwrite) begin
				regs(regAddr*32+31 downto regAddr*32) <= apbi.pwdata;
			end if;
		end if;
	end process;

	-- read from registers
	apbi.prdata <= regi(regAddr*32+31 downto regAddr*32) when (apbi.psel(PINDEX) and apbi.penable and not apbi.pwrite) else (others => '0');

end behavioral;