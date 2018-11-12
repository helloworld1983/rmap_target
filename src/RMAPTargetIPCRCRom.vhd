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

entity RMAPTargetIPCRCRom is 
	port (
		clk     : in  std_logic                           ;
		rst     : in  std_logic                           ;
		address : in  std_logic_vector(8 downto 0)        ;
		dataOut : out std_logic_vector(7 downto 0)
	);
end RMAPTargetIPCRCRom;

architecture behavioral of RMAPTargetIPCRCRom is
    
	type memory_t is array (0 to 511) of std_logic_vector(7 downto 0);

	signal mem : memory_t := (x"00",x"07",x"0e",x"09",x"1c",x"1b",x"12",x"15",
	                          x"38",x"3f",x"36",x"31",x"24",x"23",x"2a",x"2d",
	                          x"70",x"77",x"7e",x"79",x"6c",x"6b",x"62",x"65",
	                          x"48",x"4f",x"46",x"41",x"54",x"53",x"5a",x"5d",
	                          x"e0",x"e7",x"ee",x"e9",x"fc",x"fb",x"f2",x"f5",
	                          x"d8",x"df",x"d6",x"d1",x"c4",x"c3",x"ca",x"cd",
	                          x"90",x"97",x"9e",x"99",x"8c",x"8b",x"82",x"85",
	                          x"a8",x"af",x"a6",x"a1",x"b4",x"b3",x"ba",x"bd",
	                          x"c7",x"c0",x"c9",x"ce",x"db",x"dc",x"d5",x"d2",
	                          x"ff",x"f8",x"f1",x"f6",x"e3",x"e4",x"ed",x"ea",
	                          x"b7",x"b0",x"b9",x"be",x"ab",x"ac",x"a5",x"a2",
	                          x"8f",x"88",x"81",x"86",x"93",x"94",x"9d",x"9a",
	                          x"27",x"20",x"29",x"2e",x"3b",x"3c",x"35",x"32",
	                          x"1f",x"18",x"11",x"16",x"03",x"04",x"0d",x"0a",
	                          x"57",x"50",x"59",x"5e",x"4b",x"4c",x"45",x"42",
	                          x"6f",x"68",x"61",x"66",x"73",x"74",x"7d",x"7a",
	                          x"89",x"8e",x"87",x"80",x"95",x"92",x"9b",x"9c",
	                          x"b1",x"b6",x"bf",x"b8",x"ad",x"aa",x"a3",x"a4",
	                          x"f9",x"fe",x"f7",x"f0",x"e5",x"e2",x"eb",x"ec",
	                          x"c1",x"c6",x"cf",x"c8",x"dd",x"da",x"d3",x"d4",
	                          x"69",x"6e",x"67",x"60",x"75",x"72",x"7b",x"7c",
	                          x"51",x"56",x"5f",x"58",x"4d",x"4a",x"43",x"44",
	                          x"19",x"1e",x"17",x"10",x"05",x"02",x"0b",x"0c",
	                          x"21",x"26",x"2f",x"28",x"3d",x"3a",x"33",x"34",
	                          x"4e",x"49",x"40",x"47",x"52",x"55",x"5c",x"5b",
	                          x"76",x"71",x"78",x"7f",x"6a",x"6d",x"64",x"63",
	                          x"3e",x"39",x"30",x"37",x"22",x"25",x"2c",x"2b",
	                          x"06",x"01",x"08",x"0f",x"1a",x"1d",x"14",x"13",
	                          x"ae",x"a9",x"a0",x"a7",x"b2",x"b5",x"bc",x"bb",
	                          x"96",x"91",x"98",x"9f",x"8a",x"8d",x"84",x"83",
	                          x"de",x"d9",x"d0",x"d7",x"c2",x"c5",x"cc",x"cb",
	                          x"e6",x"e1",x"e8",x"ef",x"fa",x"fd",x"f4",x"f3",
	                          x"00",x"91",x"e3",x"72",x"07",x"96",x"e4",x"75",
	                          x"0e",x"9f",x"ed",x"7c",x"09",x"98",x"ea",x"7b",
	                          x"1c",x"8d",x"ff",x"6e",x"1b",x"8a",x"f8",x"69",
	                          x"12",x"83",x"f1",x"60",x"15",x"84",x"f6",x"67",
	                          x"38",x"a9",x"db",x"4a",x"3f",x"ae",x"dc",x"4d",
	                          x"36",x"a7",x"d5",x"44",x"31",x"a0",x"d2",x"43",
	                          x"24",x"b5",x"c7",x"56",x"23",x"b2",x"c0",x"51",
	                          x"2a",x"bb",x"c9",x"58",x"2d",x"bc",x"ce",x"5f",
	                          x"70",x"e1",x"93",x"02",x"77",x"e6",x"94",x"05",
	                          x"7e",x"ef",x"9d",x"0c",x"79",x"e8",x"9a",x"0b",
	                          x"6c",x"fd",x"8f",x"1e",x"6b",x"fa",x"88",x"19",
	                          x"62",x"f3",x"81",x"10",x"65",x"f4",x"86",x"17",
	                          x"48",x"d9",x"ab",x"3a",x"4f",x"de",x"ac",x"3d",
	                          x"46",x"d7",x"a5",x"34",x"41",x"d0",x"a2",x"33",
	                          x"54",x"c5",x"b7",x"26",x"53",x"c2",x"b0",x"21",
	                          x"5a",x"cb",x"b9",x"28",x"5d",x"cc",x"be",x"2f",
	                          x"e0",x"71",x"03",x"92",x"e7",x"76",x"04",x"95",
	                          x"ee",x"7f",x"0d",x"9c",x"e9",x"78",x"0a",x"9b",
	                          x"fc",x"6d",x"1f",x"8e",x"fb",x"6a",x"18",x"89",
	                          x"f2",x"63",x"11",x"80",x"f5",x"64",x"16",x"87",
	                          x"d8",x"49",x"3b",x"aa",x"df",x"4e",x"3c",x"ad",
	                          x"d6",x"47",x"35",x"a4",x"d1",x"40",x"32",x"a3",
	                          x"c4",x"55",x"27",x"b6",x"c3",x"52",x"20",x"b1",
	                          x"ca",x"5b",x"29",x"b8",x"cd",x"5c",x"2e",x"bf",
	                          x"90",x"01",x"73",x"e2",x"97",x"06",x"74",x"e5",
	                          x"9e",x"0f",x"7d",x"ec",x"99",x"08",x"7a",x"eb",
	                          x"8c",x"1d",x"6f",x"fe",x"8b",x"1a",x"68",x"f9",
	                          x"82",x"13",x"61",x"f0",x"85",x"14",x"66",x"f7",
	                          x"a8",x"39",x"4b",x"da",x"af",x"3e",x"4c",x"dd",
	                          x"a6",x"37",x"45",x"d4",x"a1",x"30",x"42",x"d3",
	                          x"b4",x"25",x"57",x"c6",x"b3",x"22",x"50",x"c1",
	                          x"ba",x"2b",x"59",x"c8",x"bd",x"2c",x"5e",x"cf");

begin

	process (rst, clk) begin
		if (rst = '1') then
			dataOut <= x"00";
		elsif (rising_edge(clk)) then
			dataOut <= mem(to_integer(unsigned(address)));
		end if;
	end process;

end behavioral;