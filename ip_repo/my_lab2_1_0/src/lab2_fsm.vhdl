----------------------------------------------------------------------------------
-- Name:	Template by George York (modified from Jeff Falkinburg)
-- Date:	Spring 2023
-- File:    lab2_fsm.vhd
-- HW:	    Lab 2 
-- Pupr:	Lab 2 Finite State Machine for the write circuitry.  
--
-- Doc:	Adapted from Dr Coulston's Lab exercise
-- 	
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity lab2_fsm is
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (2 downto 0);
           cw : out  STD_LOGIC_VECTOR (2 downto 0));
end lab2_fsm;

architecture Behavioral of lab2_fsm is

	type state_type is (WAIT_TRIG, WRITE, HOLD);
	signal state: state_type := WAIT_TRIG;

begin

	-------------------------------------------------------------------------------
	--		SW		meaning
	--		
	-------------------------------------------------------------------------------
	state_proces: process(clk)  
	begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= WAIT_TRIG;
			else 
				case state is
				    when WAIT_TRIG =>
				       state <= HOLD when (sw(2) = '1');
					when HOLD =>
			           state <= WRITE when sw(0) = '1' else
			                    HOLD;
			        when WRITE =>
			             state <= WAIT_TRIG when (sw(1) = '1') else
			                      HOLD;					
				end case;
			end if;
		end if;
	end process;

	-------------------------------------------------------------------------------
	--  CW output table
	--		CW		meaning
	cw <= "111" when state = WRITE else
	      "110";		
	-------------------------------------------------------------------------------
	
	-- NEED_SOMETHING_HERE

end Behavioral;

