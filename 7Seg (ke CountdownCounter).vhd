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
ENTITY Dec7Seg IS
	PORT
	(

		I     : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		TGL_7 : IN  STD_LOGIC;
		O     : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

	);
END Dec7Seg;

ARCHITECTURE arch_Dec7Seg OF Dec7Seg IS

BEGIN
	-- BCD to 7Seg dengan TGL_7 sebagai enabler 
	-- TGL_7 merupakan imitasi dari BI/RBO
	-- O merupakan ABCDEFG. Dibuat bus agar rapi
	O(6) <= ((I(2) XNOR I(0)) OR (I(1) OR I(3))) AND TGL_7;
	O(5) <= ((I(1) XNOR I(0)) OR (NOT I(2))) AND TGL_7;
	O(4) <= ((I(2) OR (NOT I(1))) OR I(0)) AND TGL_7;
	O(3) <= (I(3) OR ((NOT I(2)) AND I(1)) OR ((NOT I(2)) AND (NOT I(0))) OR
	(I(1) AND (NOT I(0))) OR (I(2) AND I(0) AND (NOT I(1)))) AND TGL_7;
	O(2) <= ((NOT(I(0)) AND ((NOT I(2)) OR I(1))) AND TGL_7);
	O(1) <= (I(3) OR (I(2) AND (NOT I(0))) OR (I(2) AND (NOT I(1))) OR
	(NOT (I(1) OR I(0)))) AND TGL_7;
	O(0) <= (I(3) OR (I(2) XOR I(1)) OR (I(2) OR (NOT I(0)))) AND TGL_7;

END arch_Dec7Seg;