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
ENTITY fsm IS
	PORT
	(
		I, CLK : IN  STD_LOGIC;
		Soda   : OUT STD_LOGIC
	);
END fsm;

ARCHITECTURE arc_fsm OF fsm IS
	TYPE states IS (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	SIGNAL PS, NS : states;
BEGIN
	sync_proc : PROCESS (CLK, NS)
	BEGIN
		IF (rising_edge(I)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS, I)
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