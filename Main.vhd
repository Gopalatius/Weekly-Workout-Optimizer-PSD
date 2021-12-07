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

END fsm;

ARCHITECTURE arc_fsm OF fsm IS
	--ini input dari user. Harusnya ada button, tetapi
	-- karena simulasi jadi dianggap sinyal saja
	signal BTN : STD_LOGIC;
	-- BTN -> Toggle
	
	
	--ini dari Analog to Digital Converter.
	--Thermistor mendeteksi workout optimal.
	--jangan tertukar dengan OPT_Q2 nanti
	signal OPTIMAL: STD_LOGIC
	-- OPTIMAL OptimalLogic* -> OptimalNotification, FSM
	
	
	--ini buffer dari NICE & POOR logic ke 7segment asli.
	signal real_O1, real_O2, real_O3, real_O4: STD_LOGIC (6 downto 0);


	SIGNAL ALL_0, TOGGLE, BTN_7, IS_7 : STD_LOGIC;
	-- ALL_0  dari OtherLogic ke fsm ini
	-- TOGGLE dari Toggle ke Clock, Other Logic, dan fsm ini
	
	--komponen FSM
	TYPE states IS (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	SIGNAL PS, NS                              : states;
	
	
	
	--dijadikan intermediate signal agar bisa dimasukkan
	--ke dalam sensitivity list. Tidak ada di proteus
	SIGNAL ALL_0_AND_TOGGLE                    : STD_LOGIC;
	SIGNAL JUMLAH_WORKOUT                      : STD_LOGIC (2 downto 0);
BEGIN
	--dijadikan intermediate signal agar bisa dimasukkan
	--ke dalam sensitivity list
	ALL_0_AND_TOGGLE <= ALL_0 AND TOGGLE;

	sync_proc : PROCESS (ALL_0_AND_TOGGLE) IS
	BEGIN
		IF (rising_edge(ALL_0_AND_TOGGLE)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS, I) IS
	BEGIN
		

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