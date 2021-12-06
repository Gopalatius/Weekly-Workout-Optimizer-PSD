--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY otherLogic IS
	PORT 
	(
		TOGGLE, IS_7, BTN, CLK : IN STD_LOGIC; 
		Qin : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		A1, A2 : IN STD_LOGIC;
		TGL_7, BTN_7, CLK_STOP, ALL_0 : OUT STD_LOGIC;
		A1_out, A2_out : OUT STD_LOGIC
	);
END otherLogic;

ARCHITECTURE otherLogicArch OF otherLogic IS

	SIGNAL all0Signal : STD_LOGIC;
	SIGNAL clkStopSignal : STD_LOGIC;

BEGIN
	-- reset tanggal setelah 7 hari
	TGL_7 <= TOGGLE AND (NOT IS_7);

	-- button_7
	BTN_7 <= IS_7 AND BTN;

	PROCESS (Qin, CLK)
	BEGIN
		-- keluaran dari ALL_0
		all0Signal <= ((Qin(0) NOR Qin(1)) NOR (Qin(2) NOR Qin(3))) NOR ((Qin(4) NOR Qin(5)) NOR (Qin(6) OR Qin(7)));

		-- untuk clock stop
		clkStopSignal <= (NOT all0Signal) AND CLK;

	END PROCESS;

	ALL_0 <= all0Signal;
	CLK_STOP <= clkStopSignal;
    
    --1A_ and 2A_ output
	A1_out <= ((NOT Qin(0)) AND Qin(1) AND Qin(2)) OR A1;
	A2_out <= ((NOT Qin(4)) AND Qin(5) AND Qin(6) AND TOGGLE) OR A2;

END otherLogicArch;