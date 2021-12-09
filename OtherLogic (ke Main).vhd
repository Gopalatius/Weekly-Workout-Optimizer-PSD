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

ENTITY otherLogic IS
	PORT
	(
		--A1 dan A2 dan A1_out A2_out tidak dibutuhkan lagi
		--karena decoder sudah benar.

		TOGGLE, IS_7, BTN, CLK        : IN  STD_LOGIC;
		Qin                           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		TGL_7, BTN_7, CLK_STOP, ALL_0 : OUT STD_LOGIC
		
	);
END otherLogic;

ARCHITECTURE otherLogicArch OF otherLogic IS

	SIGNAL all0Signal    : STD_LOGIC := '0';
	SIGNAL clkStopSignal : STD_LOGIC := '0';

BEGIN
	-- Jika alat tidak menyala (dari toggle)
	-- dan workout ke-7, maka ini akan berguna untuk
	-- mematikan 7segment agar '0' semua
	TGL_7 <= TOGGLE AND (NOT IS_7);

	-- Jika sudah workout ke-7 dan tombol ditekan,
	-- maka ini akan mereset state (Q = "000" dan
	-- kembali ke state awal)
	BTN_7 <= IS_7 AND BTN;
	
	clkStopSignal <= (NOT all0Signal) AND CLK;
	
	all0Signal    <= NOT (Qin(0) OR Qin(1) OR Qin(2) OR Qin(3) OR Qin(4) OR Qin(5) OR Qin(6) OR Qin(7));
	

	ALL_0    <= all0Signal;
	CLK_STOP <= clkStopSignal;

	-- tidak dibutuhkan lagi karena decodernya sudah benar
	--1A_ and 2A_ output
	-- A1_out   <= ((NOT Qin(0)) AND Qin(1) AND Qin(2)) OR A1;
	-- A2_out   <= ((NOT Qin(4)) AND Qin(5) AND Qin(6) AND TOGGLE) OR A2;
END otherLogicArch;