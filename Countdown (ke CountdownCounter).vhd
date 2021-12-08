--sebelum push, format dulu di
--https://g2384.github.io/VHDLFormatter/
--pilih UPPERCASE semua
--Show More Settings
--NEW LINE semua
--centang Align Signs in all places Mode global, align comments juga
--centang customise Indentation, \t (one tab aja tulisannya)
--centang add a new line at the end of file

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.all;


ENTITY CountDown IS
	PORT
	(
		--ini nanti load colok ke button
		D         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		CLK, LOAD : IN  STD_LOGIC;
		Q         : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		TCD       : OUT STD_LOGIC

	);
END CountDown;

ARCHITECTURE arch_CountDown OF CountDown IS

	SIGNAL temp : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
BEGIN
	countdown_proc : PROCESS (CLK, LOAD) IS
	BEGIN
		TCD <= '1';
		IF (LOAD = '1') THEN
			temp <= D;
		ELSIF (rising_edge(CLK)) THEN
			temp <= temp - 1;
		ELSIF (falling_edge(CLK) AND (temp = "1111")) THEN
			TCD <= '0';
		END IF;

	END PROCESS;

	Q <= temp;

END arch_CountDown;