--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY optNotif IS
	PORT 
	(
 
		ALL_0, TOGGLE, OPTIMAL : IN STD_LOGIC;
		Buzzer_opt, Buzzer_non_opt : OUT STD_LOGIC

	);
END optNotif;

ARCHITECTURE optNotif_arch OF optNotif IS
 

BEGIN
	Buzzer_opt <= ALL_0 AND OPTIMAL AND TOGGLE;
	Buzzer_non_opt <= ALL_0 AND (NOT(OPTIMAL)) AND TOGGLE;

END optNotif_arch;