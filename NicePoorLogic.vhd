--VHDL code for 

--library and pacakge
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY nicePoorLogic IS
	PORT (
		IS_7, OPT_Q2, OPT_Q2' : IN STD_LOGIC;
		1A_, 1B_, 1C_, 1D_, 1E_, 1F_, 1G_ : IN STD_LOGIC;
		2A_, 2B_, 2C_, 2D_, 2E_, 2F_, 2G_ : OUT STD_LOGIC;

		1A, 1B, 1C, 1D, 1E, 1F, 1G : OUT STD_LOGIC;
		2A, 2B, 2C, 2D, 2E, 2F, 2G : OUT STD_LOGIC;
		3A, 3B, 3C, 3D, 3E, 3F, 3G : OUT STD_LOGIC;
		4A, 4B, 4C, 4D, 4E, 4F, 4G : OUT STD_LOGIC
	);
END nicePoorLogic;

ARCHITECTURE nicePoorLogic_arc OF nicePoorLogic IS
BEGIN
	1A <= 1A_ OR (OPT_Q2 AND IS_7);
	1B <= 1B_;
	1C <= 1C_;
	1D <= 1D_ OR (OPT_Q2 AND IS_7);
	1E <= 1E_ OR ('1' AND IS_7);
	1F <= 1F OR (OPT_Q2 AND IS_7);
	1G <= 1G OR ('1' AND IS_7);

	2A <= 2A_ OR ('1' AND IS_7);
	2B <= 2B_ OR (OPT_Q2' AND IS_7);
	2C <= 2C_ OR (OPT_Q2' AND IS_7);
	2D <= 2D_ OR ('1' AND IS_7);
	2E <= 2E_ OR ('1' AND IS_7);
	2F <= 2F_ OR ('1' AND IS_7);
	2G <= 2G_;

	3A <= OPT_Q2' AND IS_7;
	3B <= OPT_Q2' AND IS_7;
	3C <= OPT_Q2' AND IS_7;
	3D <= OPT_Q2' AND IS_7;
	3E <= OPT_Q2' AND IS_7;
	3F <= '1' AND IS_7;
	3G <= '0';

	4A <= '1' AND IS_7;
	4B <= '1' AND IS_7;
	4C <= OPT_Q2 AND IS_7;
	4D <= '0';
	4E <= '1' AND IS_7;
	4F <= '1' AND IS_7;
	4G <= OPT_Q2' AND IS_7;

END nicePoorLogic_arc;