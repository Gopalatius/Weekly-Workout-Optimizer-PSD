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

ENTITY fsm IS
	PORT
	(
		BTN : IN STD_LOGIC;
		A1, B1, C1, D1, E1, F1, G1,
		A2, B2, C2, D2, E2, F2, G2,
		A3, B3, C3, D3, E3, F3, G3,
		A4, B4, C4, D4, E4, F4, G4, : OUT STD_LOGIC
	);
END fsm;

ARCHITECTURE arc_fsm OF fsm IS
	TYPE states IS (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	SIGNAL PS, NS                              : states;
	SIGNAL ALL_0, TOGGLE, OPTIMAL, BTN_7, IS_7 : STD_LOGIC;
	SIGNAL ALL_0_AND_TOGGLE                    : STD_LOGIC;
	SIGNAL JUMLAH_WORKOUT                      : STD_LOGIC;
BEGIN
	ALL_0_AND_TOGGLE <= ALL_0 AND TOGGLE;

	sync_proc : PROCESS (ALL_0_AND_TOGGLE) IS
	BEGIN
		IF (rising_edge(ALL_0_AND_TOGGLE)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS, I) IS
	BEGIN
		Soda <= '0';

		CASE PS IS
			WHEN ST0 =>
				IF (N = '1') THEN
					NS <= ST1;
				ELSIF (D = '1') THEN
					NS <= ST2;
				ELSE
					NS <= ST0;
				END IF;
			WHEN ST1 =>
				IF (N = '1') THEN
					NS <= ST2;
				ELSIF (D = '1') THEN
					NS <= ST3;
				ELSE
					NS <= ST1;
				END IF;
			WHEN ST2 =>
				IF (N = '1') THEN
					NS <= ST3;
				ELSIF (D = '1') THEN
					NS <= ST3;
				ELSE
					NS <= ST2;
				END IF;
			WHEN ST3 =>
				NS <= ST0;
			WHEN OTHERS =>
				NS <= ST0;
		END CASE;
	END PROCESS;

	WITH PS SELECT
		Soda <= '1' WHEN ST3,
		'0' WHEN OTHERS;

END arc_fsm;