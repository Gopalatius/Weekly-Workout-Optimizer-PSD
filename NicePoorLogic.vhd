--sebelum push, format dulu di
--https://g2384.github.io/VHDLFormatter/
--pilih UPPERCASE semua
--Show More Settings
--NEW LINE semua
--centang Align Signs in all places Mode global, align comments juga
--centang customise Indentation, \t (one tab aja tulisannya)
--centang add a new line at the end of file

--VHDL Code for 7 segment Decoder displaying Nice or Poor
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY nicePoorLogic IS
	PORT (
		IS_7, OPT_Q2, OPT_Q2' 				: IN STD_LOGIC;
		A_1, B_1, C_1, D_1, E_1, F_1, G_1 	: IN STD_LOGIC;
		A_2, B_2, C_2, D_2, E_2, F_2, G_2 	: OUT STD_LOGIC;

		A1, B1, C1, D1, E1, F1, G1 : OUT STD_LOGIC;
		A2, B2, C2, D2, E2, F2, G2 : OUT STD_LOGIC;
		A3, B3, C3, D3, E3, F3, G3 : OUT STD_LOGIC;
		A4, B4, C4, D4, E4, F4, G4 : OUT STD_LOGIC
	);
END nicePoorLogic;

ARCHITECTURE nicePoorLogic_arc OF nicePoorLogic IS
BEGIN
	A1 <= A_1 OR (OPT_Q2 AND IS_7);
	B1 <= B_1;
	C1 <= C_;
	D1 <= D_1 OR (OPT_Q2 AND IS_7);
	E1 <= E_1 OR ('1' AND IS_7);
	F1 <= F1 OR (OPT_Q2 AND IS_7);
	G1 <= G1 OR ('1' AND IS_7);

	A2 <= A_2 OR ('1' AND IS_7);
	B2 <= B_2 OR (OPT_Q2' AND IS_7);
	C2 <= C_2 OR (OPT_Q2' AND IS_7);
	D2 <= D_2 OR ('1' AND IS_7);
	E2 <= E_2 OR ('1' AND IS_7);
	F2 <= F_2 OR ('1' AND IS_7);
	G2 <= G_2;

	A3 <= OPT_Q2' AND IS_7;
	B3 <= OPT_Q2' AND IS_7;
	C3 <= OPT_Q2' AND IS_7;
	D3 <= OPT_Q2' AND IS_7;
	E3 <= OPT_Q2' AND IS_7;
	F3 <= '1' AND IS_7;
	G3 <= '0';

	A4 <= '1' AND IS_7;
	B4 <= '1' AND IS_7;
	C4 <= OPT_Q2 AND IS_7;
	D4 <= '0';
	E4 <= '1' AND IS_7;
	F4 <= '1' AND IS_7;
	G4 <= OPT_Q2' AND IS_7;

END nicePoorLogic_arc;