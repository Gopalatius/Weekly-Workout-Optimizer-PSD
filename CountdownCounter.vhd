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
		CLK_STOP, BTN, TGL_7 : IN  STD_LOGIC;
		Q                    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		A1__, B1_, C1_, D1_, E1_, F1_, G1_,
		A2__, B2_, C2_, D2_, E2_, F2_, G2_ : OUT STD_LOGIC

	);
END CountDownCounter;

ARCHITECTURE arch_CountDownCounter OF CountDownCounter IS
	COMPONENT Dec7Seg IS
		PORT
		(

			I                   : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			TGL_7               : IN  STD_LOGIC;
			A, B, C, D, E, F, G : OUT STD_LOGIC

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
	MAP (I => Q_temp(3 DOWNTO 0), TGL_7 => TGL_7, A => A1__, B => B1_, C => C1_, D => D1_, E => E1_, F => F1_, G => G1_);

	decoder2 : Dec7Seg PORT
	MAP (I => Q_temp(7 DOWNTO 4), TGL_7 => TGL_7, A => A2__, B => B2_, C => C2_, D => D2_, E => E2_, F => F2_, G => G2_);

	Q <= Q_temp;

END arch_CountDown;