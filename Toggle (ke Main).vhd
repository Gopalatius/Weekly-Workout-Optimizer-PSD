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
ENTITY toggle_comp IS
	PORT
	(

		BTN    : IN  STD_LOGIC;
		TOGGLE : OUT STD_LOGIC

	);
END toggle_comp;

ARCHITECTURE toggle_arch OF toggle_comp IS
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