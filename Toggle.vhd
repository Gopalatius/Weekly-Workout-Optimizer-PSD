--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY toggle IS
	PORT 
	(

		BTN : IN STD_LOGIC;
		TOGGLE : OUT STD_LOGIC

	);
END toggle;

ARCHITECTURE toggle_arch OF toggle IS
	SIGNAL buff_toggle : STD_LOGIC := '0';

BEGIN
	TOGGLE <= buff_toggle;
 
	toggle_proc : PROCESS (BTN)
	BEGIN
		IF (rising_edge(BTN)) THEN
			buff_toggle <= NOT(buff_toggle);
		END IF;
	END PROCESS;

END toggle_arch;