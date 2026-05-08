----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 08:14:12 AM
-- Design Name: 
-- Module Name: ZoGolf_DataPath - Behavioral
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
library UNIMACRO;
use UNIMACRO.vcomponents.all;
library UNISIM;
use UNISIM.VComponents.all;	
use work.ece383_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ZoGolf_DataPath is
    Port ( 
    clk : in  STD_LOGIC;
	reset_n : in  STD_LOGIC;
	tmds : out STD_LOGIC_VECTOR (3 downto 0);
    tmdsb : out STD_LOGIC_VECTOR (3 downto 0); 
    NES_buttons : out STD_LOGIC_VECTOR(7 downto 0);
    latch : out STD_LOGIC; --NES
    pulse : out STD_LOGIC; --NES
    data : in STD_LOGIC;  --NES
    ps2_clk     : inout std_logic;
    ps2_data    : inout std_logic;
    mouse_pos   : out std_logic_vector(15 downto 0);
    level_sel : in std_logic_vector(3 downto 0);
    ball_pos : in std_logic_vector(15 downto 0);
    frame_flag : out std_logic;
    clear_flag : in std_logic;
    show_win : in std_logic;
    score_hits : in std_logic_vector(7 downto 0));
end ZoGolf_DataPath;



architecture ZoGolf_Datapath_arch of ZoGolf_DataPath is

component NES_Controller is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           buttons : out STD_LOGIC_VECTOR (7 downto 0);
           latch : out STD_LOGIC;
           pulse : out STD_LOGIC;
           data : in STD_LOGIC);
end component;

component PS2_mouse_decoder is
    Port ( clk : in std_logic;
           reset_n : in std_logic;
           PS2_clk : inout std_logic;
           PS2_data : inout std_logic;
           mouse_coords : out STD_LOGIC_VECTOR(15 downto 0)); -- 15 to 8 is y, 0 to 0 is x
end component;

    signal sw_frame: std_logic;
    signal sw_last_address: std_logic;
    
    signal BRAM_DO : STD_LOGIC_VECTOR(3 downto 0);
    signal BRAM_pos_sel : STD_LOGIC_VECTOR(13 downto 0);
    
    signal w_NES_buttons : STD_LOGIC_VECTOR(7 downto 0);
    
    signal PS2_coords : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    signal ball_reg : STD_LOGIC_VECTOR(15 downto 0);
    signal level_reg : STD_LOGIC_Vector(3 downto 0);
    signal w_show_win : std_logic;
    signal w_frame_flag : std_logic;
    signal w_score : std_logic_vector(7 downto 0);
    
    signal position : coordinate_t;
    
begin

 --logic for the FLAG register (tells the register when a frame is complete, used for animations)
	process (clk)
	begin
    	if (rising_edge(clk)) then
			if reset_n = '0' then
				frame_flag <= '0';
		    elsif (w_frame_flag = '0' and clear_flag = '1') then
		        frame_flag <= '0';
		    elsif (w_frame_flag = '1' and clear_flag = '0') then
		        frame_flag <= '1';
				
			end if;
		end if;
	end process;

	
	video_inst : video port map(
	        clk         => clk,
            reset_n     => reset_n,
            tmds        => tmds,
            tmdsb       => tmdsb,
            position    => position,
            BRAM_pos    => BRAM_pos_sel,
            BRAM_in     => BRAM_DO,
            NES_buttons => w_NES_buttons,
            ball_pos    => ball_reg,
		    mouse_pos   => PS2_coords,
		    level_select => level_reg,
		    show_win => w_show_win,
		    score => w_score);
		    
		    
    level_selctor_inst : BRAM_Level_Selector Port map( 
           clk       => clk,
           reset_n   => reset_n,
           level_sel => level_reg,
           position  => BRAM_pos_sel,
           data_out  => BRAM_DO);

-- NES controller 
NES_inst :NES_Controller Port map( 
           clk      => clk,
           reset_n  => reset_n,
           buttons  => w_NES_buttons,
           latch    => latch,
           pulse    => pulse,
           data     => data);

    --sw(0) <= sw_ready;
    --sw(1) <= sw_last_address; --needed?
  
 PS2_decoder_inst : PS2_mouse_decoder port map(
        clk => clk,
        reset_n => reset_n,
        PS2_clk => PS2_clk,
        PS2_data => PS2_data,
        mouse_coords => PS2_coords);
    
-- PORTS from Register
   NES_buttons <= w_NES_buttons;
   mouse_pos <= PS2_coords;
   ball_reg <= ball_pos;
   level_reg <= level_sel;
   w_show_win <= show_win;
   w_score <= score_hits;
   
   
   w_frame_flag <= '1' when (position.row = 479 and position.col = 599) else
                  '0';  
    
end ZoGolf_Datapath_arch;
