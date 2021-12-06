--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Dec7Seg IS
	PORT 
	(

		I : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		TGL_7 : IN STD_LOGIC;
		A, B, C, D, E, F, G : OUT STD_LOGIC

	);
END Dec7Seg;

ARCHITECTURE arch_Dec7Seg OF Dec7Seg IS

BEGIN
	--BCD to 7Seg dengan TGL_7 sebagai enabler 
	--TGL_7 merupakan imitasi dari BI/RBO
	A <= (I(2) XNOR I(0) OR I(1) OR I(3)) AND TGL_7;
	B <= (I(1) XNOR I(0) OR (NOT I(2))) AND TGL_7;
	C <= (I(2) OR (NOT I(1)) OR I(0)) AND TGL_7;
	D <= (I(3) OR ((NOT I(2)) AND I(1)) OR ((NOT I(2)) AND (NOT I(0))) OR
		(I(1) AND (NOT I(0))) OR (I(2) AND I(0) AND (NOT I(1)))) AND TGL_7;
	E <= ((NOT(I(0)) AND ((NOT I(2)) OR I(1))) AND TGL_7;
	F <= (I(3) OR (I(2) AND (NOT I(0))) OR (I(2) AND (NOT I(1))) OR
			(NOT (I(1) OR I(0)))) AND TGL_7;
	G <= (I(3) OR (I(2) XOR I(1)) OR (I(2) OR (NOT I(0)))) AND TGL_7;

END arch_Dec7Seg;