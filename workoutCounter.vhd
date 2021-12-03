LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_ARITH.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY wrkCount IS
    	PORT 
    	(

    	    	ALL_0, TOGGLE, OPTIMAL : IN STD_LOGIC;
    	    	BTN_7 : IN STD_LOGIC;

    	    	Q_JML_WORKOUT : OUT STD_LOGIC_VECTOR(0 TO 3);
    	    	IS_7, OPT_Q2, OPT_Q2aks : OUT STD_LOGIC
    	);
END wrkCount;

ARCHITECTURE wrkCountArch OF wrkCount IS
    	SIGNAL jmlWorkClk : STD_LOGIC;
    	SIGNAL count : STD_LOGIC_VECTOR(0 TO 3) := "0000";

BEGIN
    	jmlWorkClk <= ALL_0 AND TOGGLE;
    	PROCESS (BTN_7, jmlWorkClk)
    	BEGIN
    	    	IF (BTN_7 = '1') THEN
    	    	    	count <= "0000";

    	    	ELSIF (rising_edge(jmlWorkClk)) THEN
    	    	    	count <= count + 1;

    	    	END IF;

    	END PROCESS;
    	Q_JML_WORKOUT <= count;
    	IS_7 <= Q_JML_WORKOUT(0) AND Q_JML_WORKOUT(1) AND Q_JML_WORKOUT(2);
END wrkCountArch;