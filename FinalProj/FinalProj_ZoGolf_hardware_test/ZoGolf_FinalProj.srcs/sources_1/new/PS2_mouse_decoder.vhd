----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 06:22:25 PM
-- Design Name: 
-- Module Name: PS2_mouse_decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PS2_mouse_decoder is
  Port (
    clk : in std_logic;
    reset_n : in std_logic;
    PS2_clk : inout std_logic;
    PS2_data : inout std_logic;
    mouse_coords : out STD_LOGIC_VECTOR(15 downto 0) -- 15 to 8 is y, 0 to 0 is x
  );
end PS2_mouse_decoder;

architecture Behavioral of PS2_mouse_decoder is

attribute mark_debug : string;
attribute keep       : string;

signal PS2_mouse_data : STD_LOGIC_VECTOR(23 downto 0);
--signal PS2_mouse_data_DBG : STD_LOGIC_VECTOR(23 downto 0);
--attribute mark_debug of PS2_mouse_data_DBG : signal is "true";     
--attribute keep       of PS2_mouse_data_DBG : signal is "true";

signal PS2_mouse_data_new : STD_LOGIC;
signal mouse_position : STD_LOGIC_VECTOR(15 downto 0);
type state_type is (waitNew, readData, wait_0);
signal state: state_type;

--signal PS2_clk_DBG : std_logic;
--attribute mark_debug of PS2_clk_DBG : signal is "true";     
--attribute keep       of PS2_clk_DBG : signal is "true";
--signal PS2_data_DBG : std_logic;
--attribute mark_debug of PS2_data_DBG : signal is "true";     
--attribute keep       of PS2_data_DBG : signal is "true";
--signal PS2_mouse_data_new_DBG : std_logic;
--attribute mark_debug of PS2_mouse_data_new_DBG : signal is "true";     
--attribute keep       of PS2_mouse_data_new_DBG : signal is "true";

component ps2_mouse IS
	GENERIC(
			clk_freq				   :	INTEGER := 50_000_000;	--system clock frequency in Hz
			ps2_debounce_counter_size	:	INTEGER := 8
			);				--set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
	port(
			clk				:	IN			STD_LOGIC;								--system clock input
			reset_n			:	IN			STD_LOGIC;								--active low asynchronous reset
			ps2_clk			:	INOUT		STD_LOGIC;								--clock signal from PS2 mouse
			ps2_data		:	INOUT		STD_LOGIC;								--data signal from PS2 mouse
			mouse_data		:	OUT		STD_LOGIC_VECTOR(23 DOWNTO 0);	--data received from mouse
			mouse_data_new	:	OUT		STD_LOGIC);								--new data packet available flag
END component;

begin

inst_PS2_mouse : ps2_mouse 
generic map(clk_freq => 100_000_000)
port map(
    clk      => clk,
    reset_n  => reset_n,
    PS2_clk  => PS2_clk,
    PS2_data => PS2_data,
    mouse_data      => PS2_mouse_data,
    mouse_data_new  => PS2_mouse_data_new
    );

-- process for loading mouse data
state_process: process(clk)
	 begin
		if (rising_edge(clk)) then
			if (reset_n = '0') then 
				state <= waitNew;
			else
                case state is
                    when waitNew =>
                        if (PS2_mouse_data_new = '1') then state <= readData; end if;
                    when readData =>
                        mouse_position <= PS2_to_position(PS2_mouse_data, mouse_position);
                        state <= wait_0;
                    when wait_0 =>
                       if (PS2_mouse_data_new = '0') then state <= waitNew; end if;          
				end case;
			end if;
		end if;
	end process;


--process (clk)
--begin
--if rising_edge(clk) then
--    PS2_data_DBG <= PS2_data;
--    PS2_clk_DBG <= PS2_clk;
--    PS2_mouse_data_DBG <= PS2_mouse_data;
--    PS2_mouse_data_new_DBG <= PS2_mouse_data_new;
--end if;
--end process;

mouse_coords <= mouse_position;   
end Behavioral;
