----------------------------------------------------------------------------------
-- Lt Col James Trimble, 16-Jan-2025
-- color_mapper (previously scope face) determines the pixel color value based on the row, column, triggers, and channel inputs 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;

entity color_mapper is
    Port ( color : out color_t;
           position: in coordinate_t;
           BRAM_pos : out std_logic_vector(12 downto 0);
		   level_map: in std_logic_vector(3 downto 0); -- BRAM interfacce port
		   NES_buttons : in STD_LOGIC_VECTOR(7 downto 0);
		   ball_pos: in std_logic_vector(15 downto 0);
		   mouse_pos: in std_logic_vector(15 downto 0);
		   level_select: in std_logic_vector(3 downto 0));
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal ball_color : color_t := WHITE;
signal CURSOR_COLOR : color_t := BLUE;
signal NES_PRESSED : color_t := BLUE; 
signal NES_OFF : color_t := RED;  
-- Add other colors you want to use here

signal BRAM_color_code : color_t;

-- NES button indicators
signal NES_right, NES_left, NES_up, NES_down, NES_start, NES_select, NES_B, NES_A : std_logic;
signal is_cursor : std_logic;

signal cursor_x, cursor_y : unsigned(9 downto 0);

begin

-- Assign values to booleans here
NES_right <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 520) and  (position.col <= 523))
                          else '0';
NES_left <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 526) and  (position.col <= 529))
                          else '0';
NES_down <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 532) and  (position.col <= 535))
                          else '0';
NES_up <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 538) and  (position.col <= 541))
                          else '0';
NES_start <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 544) and  (position.col <= 547))
                          else '0';
NES_select <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 550) and  (position.col <= 553))
                          else '0';
NES_B <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 556) and  (position.col <= 559))
                          else '0';
NES_A <= '1' when ((position.row >= 400) and  (position.row <= 403)) and
                          ((position.col >= 562) and  (position.col <= 565))
                          else '0';
                          
-- PS2 Mouse cursor  
cursor_x <= unsigned("00" & mouse_pos(7 downto 0));
cursor_Y <= unsigned("00" & mouse_pos(15 downto 8));

is_cursor <= '1' when ((position.row/4 = cursor_y) and (position.col/4 = cursor_x)) else
             '0';                                                                                                                            
-- coordinate to BRAM position converter
BRAM_pos <= coords_to_BRAM_address(position);

-- BRAM color decoder
BRAM_COLOR_CODE <= WHITE when (level_map = "0000") else
                   BLACK when (level_map = "0001") else
                   GREEN when (level_map = "0010") else
                   RED;
                   -- add more values post testing
                   
-- Use your booleans to choose the color
color <= CURSOR_COLOR when (is_cursor) else
         BRAM_COLOR_CODE when (position.col < 480) else
         NES_PRESSED when ((NES_right and NES_buttons(0)) or
                          (NES_left   and NES_buttons(1)) or
                          (NES_down   and NES_buttons(2)) or
                          (NES_up     and NES_buttons(3)) or
                          (NES_start  and NES_buttons(4)) or
                          (NES_select and NES_buttons(5)) or
                          (NES_B      and NES_buttons(6)) or
                          (NES_A      and NES_buttons(7))) else
         NES_OFF     when ((NES_right and not NES_buttons(0)) or
                          (NES_left   and not NES_buttons(1)) or
                          (NES_down   and not NES_buttons(2)) or
                          (NES_up     and not NES_buttons(3)) or
                          (NES_start  and not NES_buttons(4)) or
                          (NES_select and not NES_buttons(5)) or
                          (NES_B      and not NES_buttons(6)) or
                          (NES_A      and not NES_buttons(7))) else
         BEIGE;
                             
                               
end color_mapper_arch;
