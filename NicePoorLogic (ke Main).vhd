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
		-- OPT_Q2' tidak perlu
		IS_7, OPT_Q2			: IN STD_LOGIC;
		
		-- Input dari output decoder 1 dan 2 (1 LSB dan 2 MSB)
		I1, I2 : IN STD_LOGIC_VECTOR (6 downto 0);

		-- output yang menuju ke 7segment sebenarnya
		-- isinya adalah output dari downcounter dan
		-- untuk logika NICE dan POOR
		O1, O2, O3, O4 : OUT STD_LOGIC_VECTOR (6 downto 0);
		
	);
END nicePoorLogic;

ARCHITECTURE nicePoorLogic_arc OF nicePoorLogic IS
	signal OPT_Q2andIS_7 , notOPT_Q2andIS_7 : STD_LOGIC;
	
BEGIN
	--intermediate signal untuk menghemat gerbang and
	--tidak seperti di Proteus
	OPT_Q2andIS_7 <= OPT_Q2 AND IS_7;
	notOPT_Q2andIS_7 <= (not(OPT_Q2) and IS_7);

	O1(6) <= I1(6) OR OPT_Q2andIS_7;
	O1(5) <= I1(5);
	O1(4) <= I1(4);
	O1(3) <= I1(3) OR OPT_Q2andIS_7;
	-- Diubah menjadi I1(2) AND IS_7 aja.
	-- Baru sadar bahwa VCC di-AND akan ngikut
	-- dengan IS_7
	O1(2) <= I1(2) OR IS_7;
	O1(1) <= I1(1) OR OPT_Q2andIS_7;
	O1(0) <= I1(0) OR IS_7;

	O2(6) <= I2(6) OR IS_7;
	O2(5) <= I2(5) OR notOPT_Q2andIS_7;
	O2(4) <= I2(4) OR notOPT_Q2andIS_7;
	O2(3) <= I2(3) OR IS_7;
	O2(2) <= I2(2) OR IS_7;
	O2(1) <= I2(1) OR IS_7;
	O2(0) <= I2(0);

	O3(6) <= notOPT_Q2andIS_7;
	O3(5) <= notOPT_Q2andIS_7;
	O3(4) <= notOPT_Q2andIS_7;
	O3(3) <= notOPT_Q2andIS_7;
	O3(2) <= notOPT_Q2andIS_7;
	O3(1) <= IS_7;
	O3(0) <= IS_7;

	O4(6) <= IS_7;
	O4(5) <= IS_7;
	O4(4) <= OPT_Q2andIS_7;
	O4(3) <= '0';
	O4(2) <= IS_7;
	O4(1) <= IS_7;
	O4(0) <= notOPT_Q2andIS_7;

END nicePoorLogic_arc;