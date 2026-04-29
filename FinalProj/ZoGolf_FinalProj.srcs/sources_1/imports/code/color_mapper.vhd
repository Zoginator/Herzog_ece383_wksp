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
		   level_map: in std_logic_vector(15 downto 0); -- BRAM interfacce port
		   ball_pos: in std_logic_vector(19 downto 0);
		   mouse_pos: in std_logic_vector(19 downto 0);
		   level_select: in std_logic_vector(3 downto 0));
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal background_color : color_t := GREEN;
signal ball_color : color_t := WHITE;
signal Cursor_color : color_t := BLUE; 
-- Add other colors you want to use here

signal is_vertical_gridline, is_horizontal_gridline, is_within_grid, is_trigger_time, is_trigger_volt, is_ch1_line, is_ch2_line,
    is_horizontal_hash, is_vertical_hash : boolean := false;

-- Fill in values here
constant grid_start_row : integer := 20;


begin

-- Assign values to booleans here
--is_within_grid <= true when ((position.row >= grid_start_row) and  (position.row <= grid_stop_row)) and
 --                           ((position.col >= grid_start_col) and  (position.col <= grid_stop_col))
 --                           else false;

-- Use your booleans to choose the color
color <=        GREEN;                 
                               
end color_mapper_arch;
