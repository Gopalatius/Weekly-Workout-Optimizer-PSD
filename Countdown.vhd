--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
use ieee.std_logic_unsigned.ALL;

ENTITY CountDown IS
	PORT 
	(
		--ini nanti load colok ke button
		D : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		CLK, LOAD: IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR (3 downto 0);
		TCD: OUT STD_LOGIC

	);
END CountDown;

ARCHITECTURE arch_CountDown OF CountDown IS

	signal temp: std_logic_vector (3 downto 0) := "0000";
BEGIN
	
	countdown_proc: process (CLK,LOAD) is
	begin
		if (LOAD = '1') then
			temp <= D;
		elsif (rising_edge(CLK)) then
			temp <= temp - 1;
		end if;
	end process;
	
	Q <= temp;
			
END arch_CountDown;