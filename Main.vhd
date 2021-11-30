--sebelum push, format dulu di
--https://g2384.github.io/work/VHDLformatter.html
--pilih UPPERCASE
--centang New line after THEN, semicolon";"
--centang New line after PORT & GENERIC
--centang customise Indentation, \t (one tab aja tulisannya)

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY fsm IS
	PORT 
	(
		D, N, CLK : IN STD_LOGIC;
		Soda : OUT STD_LOGIC
	);
END fsm;

ARCHITECTURE arc_fsm OF fsm IS
	TYPE states IS (ST0, ST1, ST2, ST3);
	SIGNAL PS, NS : states;
BEGIN
	sync_proc : PROCESS (CLK, NS)
	BEGIN
		IF (rising_edge(CLK)) THEN
			PS <= NS;
		END IF;
	END PROCESS;
 
	comb_proc : PROCESS (PS, D, N)
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