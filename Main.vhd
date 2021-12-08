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

	SIGNAL BTN                                : STD_LOGIC                     := '0';
	-- BTN -> Toggle, Countdown Counter
	-- ini dari Analog to Digital Converter.
	-- Thermistor mendeteksi workout optimal.
	-- jangan tertukar dengan OPT_Q2 nanti
	-- ini input dari user. Harusnya ada button, tetapi
	-- karena simulasi jadi dianggap sinyal saja

	SIGNAL OPTIMAL                            : STD_LOGIC                     := '0';
	-- OPTIMAL : OptimalLogic* -> OptimalNotification, FSM
	-- OptimalLogic merupakan rangkaian Analog to Digital
	-- Converter sehingga tidak ada dalam rangkaian VHDL.

	SIGNAL real_O1, real_O2, real_O3, real_O4 : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
	--Nice&PoorLogic -> Real7Segment

	SIGNAL ALL_0, TOGGLE, BTN_7, IS_7, TGL_7  : STD_LOGIC                     := '0';
	-- ALL_0  : OtherLogic -> FSM
	-- TOGGLE : Toggle -> Clock, OtherLogic
	-- BTN_7 : OtherLogic -> FSM
	-- IS_7 : FSM -> OtherLogic, Nice&PoorLogic
	-- TGL_7 : OtherLogic -> Countdown Counter

	SIGNAL Q                                  : STD_LOGIC_VECTOR (7 DOWNTO 0) := "00000000";
	SIGNAL D1, D2                             : STD_LOGIC_VECTOR (6 DOWNTO 0) := "0000000";
	-- Q : Countdown Counter -> OtherLogic
	-- D1, D2 : Countdown Counter -> OtherLogic

	SIGNAL CLK, CLK_STOP                      : STD_LOGIC                     := '0';
	-- CLK : Clock -> OtherLogic
	-- CLK_STOP : OtherLogic -> Countdown Counter

	TYPE states IS (ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7);
	SIGNAL present_state, next_state    : states;
	--komponen FSM.
	-- states berhubungan dengan JUMLAH_WORKOUT

	-- kita tidak butuh JUMLAH_WORKOUT karena sudah direpresentasikan
	-- oleh states
	-- SIGNAL JUMLAH_WORKOUT, OPTIMAL_WORKOUT : STD_LOGIC (2 DOWNTO 0);
	SIGNAL OPTIMAL_WORKOUT              : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
	-- JUMLAH_WORKOUT : Output FSM
	-- OPTIMAL_WORKOUT : Output FSM (OPTIMAL_WORKOUT(2) terpakai sebagai OPT_Q2)

	SIGNAL Buzzer_opt, Buzzer_non_opt   : STD_LOGIC                     := '0';
	-- Membunyikan buzzer dan LED

	SIGNAL ALL_0_AND_TOGGLE             : STD_LOGIC                     := '0';
	SIGNAL ALL_0_AND_TOGGLE_AND_OPTIMAL : STD_LOGIC                     := '0';
	--dijadikan intermediate signal agar bisa dimasukkan
	--ke dalam sensitivity list. Tidak ada di proteus

	CONSTANT T                          : TIME                          := 1 ns;
	-- anggap satu detik = 1 nanodetik demi testbench di ModelSim

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
			O1, O2               : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

		);
	END COMPONENT;

	-- OtherLogic component
	COMPONENT otherLogic IS
		PORT
		(
			--A1 dan A2 dan A1_out A2_out tidak dibutuhkan lagi
			--karena decoder sudah benar.

			TOGGLE, IS_7, BTN, CLK        : IN  STD_LOGIC;
			Qin                           : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			TGL_7, BTN_7, CLK_STOP, ALL_0 : OUT STD_LOGIC

		);
	END COMPONENT;

	-- OptimalNotification component
	COMPONENT optNotif IS
		PORT
		(

			ALL_0, TOGGLE, OPTIMAL     : IN  STD_LOGIC;
			Buzzer_opt, Buzzer_non_opt : OUT STD_LOGIC

		);
	END COMPONENT;

	-- Nice&PoorLogic component
	COMPONENT nicePoorLogic IS
		PORT
		(
			-- OPT_Q2' tidak perlu
			IS_7, OPT_Q2   : IN  STD_LOGIC;

			-- Input dari output decoder 1 dan 2 (1 LSB dan 2 MSB)
			I1, I2         : IN  STD_LOGIC_VECTOR (6 DOWNTO 0);

			-- output yang menuju ke 7segment sebenarnya
			-- isinya adalah output dari downcounter dan
			-- untuk logika NICE dan POOR
			O1, O2, O3, O4 : OUT STD_LOGIC_VECTOR (6 DOWNTO 0)

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
	MAP (CLK_STOP => CLK_STOP, BTN => BTN, TGL_7 => TGL_7, Q => Q,
	O1 => D1, O2 => D2);

	--Mapping untuk otherLogic
	otherLogic_map : otherLogic PORT
	MAP (TOGGLE => TOGGLE, IS_7 => IS_7, BTN => BTN, CLK => CLK,
	Qin => Q, TGL_7 => TGL_7, BTN_7 => BTN_7, CLK_STOP => CLK_STOP,
	ALL_0 => ALL_0);

	-- Mapping untuk OptimalNotification
	optNotif_map : optNotif PORT
	MAP (ALL_0 => ALL_0, TOGGLE => TOGGLE, OPTIMAL => OPTIMAL,
	Buzzer_opt => Buzzer_opt, Buzzer_non_opt => Buzzer_non_opt);

	-- Mapping untuk NICE&POORLogic
	nicePoorLogic_map : nicePoorLogic PORT
	MAP (IS_7 => IS_7, OPT_Q2 => OPTIMAL_WORKOUT(2), I1 => D1,
	I2 => D2, O1 => real_O1, O2 => real_O2, O3 => real_O3,
	O4 => real_O4);

	-- Clock process
	clk_proc : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR T/2;
		CLK <= TOGGLE;
		WAIT FOR T/2;
	END PROCESS;

	-- Async process karena state berubah bukan karena clock,
	-- melainkan karena TOGGLE dan ALL_0
	async_proc : PROCESS (ALL_0_AND_TOGGLE, next_state, BTN_7) IS
	BEGIN
		IF (BTN_7 = '1') THEN
			present_state <= ST0;
		ELSIF (rising_edge(ALL_0_AND_TOGGLE)) THEN
			present_state <= next_state;
		END IF;
	END PROCESS;

	-- Process untuk menentukan next state nya apa
	-- next state tidak dipengaruhi oleh input
	comb_proc : PROCESS (present_state) IS
	BEGIN
		CASE present_state IS
			WHEN ST0 =>
				next_state <= ST1;
			WHEN ST1 =>
				next_state <= ST2;
			WHEN ST2 =>
				next_state <= ST3;
			WHEN ST3 =>
				next_state <= ST4;
			WHEN ST4 =>
				next_state <= ST5;
			WHEN ST5 =>
				next_state <= ST6;
			WHEN ST6 =>
				next_state <= ST7;
			WHEN ST7 =>
				next_state <= ST0;
		END CASE;
	END PROCESS;

	-- states menentukan JUMLAH_WORKOUT
	WITH present_state SELECT
		IS_7 <= '1' WHEN ST7,
		'0' WHEN OTHERS;
	WITH present_state SELECT
		OPTIMAL_WORKOUT <= "000" WHEN ST0,
		OPTIMAL_WORKOUT WHEN OTHERS;

	--counter untuk OPTIMAL_WORKOUT
	opt_workout_proc : PROCESS (ALL_0_AND_TOGGLE_AND_OPTIMAL) IS
	BEGIN
		IF (rising_edge(ALL_0_AND_TOGGLE_AND_OPTIMAL)) THEN
			OPTIMAL_WORKOUT <= OPTIMAL_WORKOUT + 1;
		END IF;
	END PROCESS;

	tb_proc : PROCESS
	BEGIN
<<<<<<< HEAD
		FOR i IN 0 TO 1 LOOP
			--iterasi hari pertama hingga hari ketujuh
			--iterasi ini untuk jika workout optimal nya < 4
			FOR j IN 0 TO 6 LOOP
				-- initial state bahwa OPTIMAL '0'
				-- karena belum mengukur suhu
				OPTIMAL <= '0';

				-- untuk menekan tombol
				BTN     <= '0';
				WAIT FOR 500 ps;
				BTN <= '1';
				WAIT FOR 500 ps;
				BTN <= '0';
				-- ini nanti akan menyalakan toggle

				-- untuk menunggu setimbang saat mengukur suhu
				-- anggap 30 detik sudah setimbang
				WAIT FOR 30 ns;

				-- untuk hari pertama sampai ketiga, workoutnya
				-- optimal
				IF ((i = 0 AND j < 3) OR (i = 1 AND j < 5) THEN
					OPTIMAL <= '1';
				END IF;

				WAIT FOR 31 ns;
				-- pengukuran suhu telah selesai

				-- jika suhu optimal ketika countdown selesai,
				-- seharusnya buzzer optimal menyala
				IF (OPTIMAL = '1') THEN
					ASSERT Buzzer_opt = '1' REPORT "Error pada buzzer optimal"
					SEVERITY error;
				ELSE
					ASSERT Buzzer_non_opt = '0' REPORT "Error pada buzzer non optimal"
					SEVERITY error;
				END IF;
				
				-- untuk menekan tombol
				BTN     <= '0';
				WAIT FOR 500 ps;
				BTN <= '1';
				WAIT FOR 500 ps;
				BTN <= '0';
				-- ini untuk mematikan Toggle

				-- cek output LED. Harusnya POOR akan muncul pada hari ketujuh
				IF (NOT (PS = ST7)) THEN
					ASSERT real_01 = "1111110" AND real_O2 = "1111110" AND
					real_O3 = "0000000" AND real_O4 = "0000000" REPORT
					"Error LED nya saat timer habis" SEVERITY error;
				ELSE
					IF (i = 0) THEN
						ASSERT real_O1 = "0000101" AND real_O2 = "1111110" AND
						real_O3 = "1111110" AND real_O4 = "1100111" AND OPTIMAL_WORKOUT = "011"
						REPORT "Error saat State7 POOR" SEVERITY error;
					ELSE
						ASSERT real_O1 = "1001111" AND real_O2 = "1001110" AND
						real_O3 = "0000110" AND real_O4 = "1110110" AND OPTIMAL_WORKOUT = "100"
						REPORT "Error saat State7 NICE" SEVERITY error;
					END IF;
				END IF;
				
				WAIT FOR 37 ns;
			END LOOP;
			--agar simulate ALL langsung berhenti
			if (i = 1) then
				WAIT;
			END IF;
		END LOOP;

/*
		--iterasi hari pertama hingga hari ketujuh
		-- untuk hari pertama hingga hari ketiga optimal
		for j in 0 to 6 loop
			-- initial state bahwa OPTIMAL '0'
			-- karena belum mengukur suhu
			OPTIMAL <= '0';
			
			-- untuk menekan tombol
			BTN <= '0';
			WAIT FOR 1 ps;
			BTN <= '1';
			WAIT FOR 1 ps;
			BTN <= '0';
			-- ini nanti akan menyalakan toggle
			
			-- untuk menunggu setimbang saat mengukur suhu
			-- anggap 30 detik sudah setimbang
			WAIT FOR 30 ns;
			
			-- untuk hari pertama sampai ketiga, workoutnya
			-- optimal
			if (j < 3) then
				OPTIMAL <= '1';
			end if;
			
			WAIT FOR 31 ns;
			--pengukuran suhu telah selesai
			OPTIMAL <= '0';
			--sekarang clock harusnya telah berhenti
			
			if (j < 3) then
				assert Buzzer_opt = '1' and real_O1 = "0000";
			end if;
		end loop;
		
		--untuk hari pertama sampai hari ke4 optimal
		for j in 0 to 6 loop
			-- initial state bahwa OPTIMAL '0'
			-- karena belum mengukur suhu
			OPTIMAL <= '0';
			
			-- untuk menekan tombol
			BTN <= '0';
			WAIT FOR 1 ps;
			BTN <= '1';
			WAIT FOR 1 ps;
			BTN <= '0';
			-- ini nanti akan menyalakan toggle
			
			-- untuk menunggu setimbang saat mengukur suhu
			-- anggap 30 detik sudah setimbang
			WAIT FOR 30 ns;
			
			-- untuk hari pertama sampai keempat, workoutnya
			-- optimal
			if (j < 4) then
				OPTIMAL <= '1';
			end if;
			
			WAIT FOR 31 ns;
			--pengukuran suhu telah selesai
			OPTIMAL <= '0';
			--sekarang clock harusnya telah berhenti
			
			if (j < 4) then
				assert Buzzer_opt = '1' and real_O1 = "0000";
			end if;
		end loop;
		
		--untuk hari pertama sampai hari keenam optimal
		for j in 0 to 6 loop
			-- initial state bahwa OPTIMAL '0'
			-- karena belum mengukur suhu
			OPTIMAL <= '0';
			
			-- untuk menekan tombol
			BTN <= '0';
			WAIT FOR 1 ps;
			BTN <= '1';
			WAIT FOR 1 ps;
			BTN <= '0';
			-- ini nanti akan menyalakan toggle
			
			-- untuk menunggu setimbang saat mengukur suhu
			-- anggap 30 detik sudah setimbang
			WAIT FOR 30 ns;
			
			-- untuk hari pertama sampai keenam, workoutnya
			-- optimal
			if (j < 6) then
				OPTIMAL <= '1';
			end if;
			
			WAIT FOR 31 ns;
			--pengukuran suhu telah selesai
			OPTIMAL <= '0';
			--sekarang clock harusnya telah berhenti
			
			if (j < 6) then
				assert Buzzer_opt = '1' and real_O1 = "0000";
			end if;
		end loop;
		
	*/
	END PROCESS;

END arc_fsm;