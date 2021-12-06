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
USE ieee.std_logic_ARITH.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY wrkCount IS
    	PORT 
    	(
            
    	    	ALL_0, TOGGLE, OPTIMAL : IN STD_LOGIC;
    	    	BTN_7 : IN STD_LOGIC;

    	    	IS_7, OPT_Q2, OPT_Q2aks : OUT STD_LOGIC

    	);
END wrkCount;

ARCHITECTURE wrkCountArch OF wrkCount IS
    	SIGNAL jmlWorkClk : STD_LOGIC;
    	SIGNAL optWorkClk : STD_LOGIC;
    	SIGNAL jmlWorkCount : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    	SIGNAL optWorkCount : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";

BEGIN
    	jmlWorkClk <= ALL_0 AND TOGGLE;
    	optWorkClk <= jmlWorkClk AND OPTIMAL;

    	PROCESS (BTN_7, jmlWorkClk, optWorkClk)
    	BEGIN
    	    	IF (BTN_7 = '1') THEN
 
    	    	    	jmlWorkCount <= "0000";

    	    	ELSIF (rising_edge(jmlWorkClk)) THEN

    	    	    	jmlWorkCount <= jmlWorkCount + 1;

    	    	END IF;

    	    	IF (BTN_7 = '1') THEN

    	    	    	optWorkCount <= "0000";

    	    	ELSIF (rising_edge(optWorkClk)) THEN

    	    	    	optWorkCount <= optWorkCount + 1;

    	    	END IF;

    	END PROCESS;

    	IS_7 <= jmlWorkCount(0) AND jmlWorkCount(1) AND jmlWorkCount(2);

    	OPT_Q2 <= optWorkCount(2);
    	OPT_Q2aks <= NOT(optWorkCount(2));

END wrkCountArch;