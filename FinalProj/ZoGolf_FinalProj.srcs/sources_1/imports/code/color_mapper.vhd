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
		   ball_pos: in std_logic_vector(19 downto 0);
		   mouse_pos: in std_logic_vector(19 downto 0);
		   level_select: in std_logic_vector(3 downto 0));
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal ball_color : color_t := WHITE;
signal Cursor_color : color_t := BLUE; 
-- Add other colors you want to use here

signal BRAM_color_code : color_t;

-- Fill in values here



begin

-- Assign values to booleans here
--is_within_grid <= true when ((position.row >= grid_start_row) and  (position.row <= grid_stop_row)) and
 --                           ((position.col >= grid_start_col) and  (position.col <= grid_stop_col))
 --                           else false;

-- coordinate to BRAM position converter
BRAM_pos <= coords_to_BRAM_address(position);

-- BRAM color decoder
BRAM_COLOR_CODE <= WHITE when (level_map = "0000") else
                   BLACK when (level_map = "0001") else
                   GREEN when (level_map = "0010") else
                   RED;
                   -- add more values post testing
                   
-- Use your booleans to choose the color
color <= BRAM_COLOR_CODE when (position.col < 480) else
         YELLOW;
                             
                               
end color_mapper_arch;
