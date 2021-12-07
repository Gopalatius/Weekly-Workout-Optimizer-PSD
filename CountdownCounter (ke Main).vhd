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
USE ieee.std_logic_unsigned.ALL;

ENTITY CountDownCounter IS
	PORT
	(
		--Di proteus BTN_NOT, di sini BTN aja
		--alasan terdapat A dibuat double underscore
		CLK_STOP, BTN, TGL_7 : IN  STD_LOGIC;
		Q                    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		O1, O2               : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

	);
END CountDownCounter;

ARCHITECTURE arch_CountDownCounter OF CountDownCounter IS
	COMPONENT Dec7Seg IS
		PORT
		(

			I     : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			TGL_7 : IN  STD_LOGIC;
			O     : OUT STD_LOGIC (6 DOWNTO 0)

		);
	END COMPONENT;

	COMPONENT CountDown IS
		PORT
		(
			--ini nanti load colok ke button
			D         : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			CLK, LOAD : IN  STD_LOGIC;
			Q         : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			TCD       : OUT STD_LOGIC

		);
	END COMPONENT;
	SIGNAL TCD     : STD_LOGIC;
	SIGNAL Q_temp  : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL GARBAGE : STD_LOGIC;

BEGIN
	counter1 : CountDown PORT MAP
		(D => "0000", CLK => CLK_STOP, LOAD => BTN, Q => Q_temp(3 DOWNTO 0), TCD => TCD);

	--TCD terakhir disambung ke garbage karena tidak diperlukan
	--tetapi port map wajib port semuanya
	counter2 : CountDown PORT
	MAP (D => "0110", CLK => TCD, LOAD => BTN, Q => Q_temp(7 DOWNTO 4), TCD => GARBAGE);

	decoder1 : Dec7Seg PORT
	MAP (I => Q_temp(3 DOWNTO 0), TGL_7 => TGL_7, O => O1);

	decoder2 : Dec7Seg PORT
	MAP (I => Q_temp(7 DOWNTO 4), TGL_7 => TGL_7, O => O2);

	Q <= Q_temp;

END arch_CountDownCounter;