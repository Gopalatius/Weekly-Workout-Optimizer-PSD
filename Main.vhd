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

	SIGNAL BTN                                : STD_LOGIC;
	-- BTN -> Toggle, Countdown Counter
	-- ini dari Analog to Digital Converter.
	-- Thermistor mendeteksi workout optimal.
	-- jangan tertukar dengan OPT_Q2 nanti
	-- ini input dari user. Harusnya ada button, tetapi
	-- karena simulasi jadi dianggap sinyal saja

	SIGNAL OPTIMAL                            : STD_LOGIC;
	-- OPTIMAL : OptimalLogic* -> OptimalNotification, FSM
	-- OptimalLogic merupakan rangkaian Analog to Digital
	-- Converter sehingga tidak ada dalam rangkaian VHDL.

	SIGNAL real_O1, real_O2, real_O3, real_O4 : STD_LOGIC_VECTOR (6 DOWNTO 0);
	--Nice&PoorLogic -> Real7Segment

	SIGNAL ALL_0, TOGGLE, BTN_7, IS_7, TGL_7  : STD_LOGIC;
	-- ALL_0  : OtherLogic -> FSM
	-- TOGGLE : Toggle -> Clock, OtherLogic
	-- BTN_7 : OtherLogic -> FSM
	-- IS_7 : FSM -> OtherLogic, Nice&PoorLogic
	-- TGL_7 : OtherLogic -> Countdown Counter

	SIGNAL Q                                  : STD_LOGIC_VECTOR (7 DOWNTO 0);
	SIGNAL D1, D2                             : STD_LOGIC_VECTOR (6 DOWNTO 0);
	-- Q : Countdown Counter -> OtherLogic
	-- D1, D2 : Countdown Counter -> OtherLogic

	SIGNAL CLK, CLK_STOP                      : STD_LOGIC;
	-- CLK : Clock -> OtherLogic
	-- CLK_STOP : OtherLogic -> Countdown Counter

	TYPE states IS (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	SIGNAL PS, NS                          : states;
	--komponen FSM.
	-- states berhubungan dengan JUMLAH_WORKOUT

	SIGNAL JUMLAH_WORKOUT, OPTIMAL_WORKOUT : STD_LOGIC (2 DOWNTO 0);
	-- JUMLAH_WORKOUT : Output FSM
	-- OPTIMAL_WORKOUT : Output FSM (OPTIMAL_WORKOUT(2) terpakai sebagai OPT_Q2)

	SIGNAL ALL_0_AND_TOGGLE                : STD_LOGIC;
	SIGNAL ALL_0_AND_TOGGLE_AND_OPTIMAL    : STD_LOGIC;
	--dijadikan intermediate signal agar bisa dimasukkan
	--ke dalam sensitivity list. Tidak ada di proteus

	--component untuk port mapping
	-- toggle component
	COMPONENT toggle_comp IS
		PORT
		(

			BTN    : IN  STD_LOGIC;
			TOGGLE : OUT STD_LOGIC

		);
	END COMPONENT;
	-- Countdown Counter component
	COMPONENT CountDownCounter IS
		PORT
		(
			--Di proteus BTN_NOT, di sini BTN aja
			CLK_STOP, BTN, TGL_7 : IN  STD_LOGIC;
			Q                    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			O1, O2               : OUT STD_LOGIC_VECTOR (6 DOWNTO 0);

		);
	END COMPONENT;

BEGIN
	-- Dijadikan intermediate signal agar bisa dimasukkan
	-- ke dalam sensitivity list
	ALL_0_AND_TOGGLE             <= ALL_0 AND TOGGLE;
	ALL_0_AND_TOGGLE_AND_OPTIMAL <= ALL_0_AND_TOGGLE AND OPTIMAL;

	-- Port mapping
	-- Mapping untuk toggle
	toggle_map : toggle_comp PORT MAP
		(BTN => BTN, TOGGLE => TOGGLE);
	-- Mapping untuk CountDownCounter
	CountDownCounter_map : CountDownCounter PORT
	MAP (CLK_STOP => CLK_STOP, BTN => BTN, TGL_7 => TGL_7, Q => Q;
	O1 => D1, O2 => D2);
	
	sync_proc : PROCESS (ALL_0_AND_TOGGLE, NS, BTN_7) IS
	BEGIN
		IF (BTN_7 = '1') THEN
			PS <= ST0;
		ELSIF (rising_edge(ALL_0_AND_TOGGLE)) THEN
			PS <= NS;
		END IF;
	END PROCESS;

	comb_proc : PROCESS (PS) IS
	BEGIN
		CASE PS IS
			WHEN ST0 =>
				NS <= ST1;
			WHEN ST1 =>
				NS <= ST2;
			WHEN ST2 =>
				NS <= ST3;
			WHEN ST3 =>
				NS <= ST4;
			WHEN ST4 =>
				NS <= ST5;
			WHEN ST5 =>
				NS <= ST6;
			WHEN ST6 =>
				NS <= ST7;
			WHEN ST7 =>
				NS <= ST0;
		END CASE;
	END PROCESS;

	-- states menentukan JUMLAH_WORKOUT
	WITH PS SELECT
		JUMLAH_WORKOUT <= "001" WHEN ST1,
		"010" WHEN ST2,
		"011" WHEN ST3,
		"100" WHEN ST4,
		"101" WHEN ST5,
		"101" WHEN ST6,
		"110" WHEN ST6,
		"111" WHEN ST7,
		"000" WHEN OTHERS;
	WITH PS SELECT
		OPTIMAL_WORKOUT <= "000" WHEN ST0;

	opt_workout_proc : PROCESS (ALL_0_AND_TOGGLE_AND_OPTIMAL) IS
	BEGIN
		IF (rising_edge(ALL_0_AND_TOGGLE_AND_OPTIMAL) THEN
			OPTIMAL_WORKOUT <= OPTIMAL_WORKOUT + 1;
		END IF;
	END PROCESS;
END arc_fsm;