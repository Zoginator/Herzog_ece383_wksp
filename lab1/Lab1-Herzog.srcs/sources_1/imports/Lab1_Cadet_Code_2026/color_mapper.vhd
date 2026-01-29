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
		   trigger : in trigger_t;
           ch1 : in channel_t;
           ch2 : in channel_t);
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal trigger_color : color_t := YELLOW;
signal grid_color : color_t := WHITE;
signal ch1_color : color_t := YELLOW;
signal ch2_color : color_t := GREEN;
signal background_color : color_t := BLACK; 
-- Add other colors you want to use here

signal is_vertical_gridline, is_horizontal_gridline, is_within_grid, is_trigger_time, is_trigger_volt, is_ch1_line, is_ch2_line,
    is_horizontal_hash, is_vertical_hash : boolean := false;

-- Fill in values here
constant grid_start_row : integer := 20;
constant grid_stop_row : integer := 420;
constant grid_start_col : integer := 20;
constant grid_stop_col : integer := 620;
constant num_horizontal_gridblocks : integer := 8; --double check
constant num_vertical_gridblocks : integer := 10;     --double check
constant center_column : integer := 320;
constant center_row : integer := 220;
constant hash_size : integer := 6;
constant hash_horizontal_spacing : integer := 15;
constant hash_vertical_spacing : integer := 10;

begin

-- Assign values to booleans here
is_within_grid <= true when ((position.row >= grid_start_row) and  (position.row <= grid_stop_row)) and
                            ((position.col >= grid_start_col) and  (position.col <= grid_stop_col))
                            else false;

is_horizontal_gridline <= true when ((position.row - grid_start_row) mod ((grid_stop_row - grid_start_row) / num_horizontal_gridblocks) = 0) and 
                          is_within_grid
                          else false;
is_vertical_gridline <= true when ((position.col - grid_start_col) mod ((grid_stop_col - grid_start_col) / num_vertical_gridblocks) = 0) and
                        is_within_grid
                        else false;


is_horizontal_hash <= true when ((position.col >= center_column - hash_size/2) and
                                (position.col <= center_column + hash_size/2)) and
                                (position.row mod hash_vertical_spacing = 0) and
                                (is_within_grid)
                                else false;
is_vertical_hash <= true when ((position.row >= center_row - hash_size/2) and
                                (position.row <= center_row + hash_size/2)) and
                                ((position.col-5)mod hash_horizontal_spacing = 0) and
                                (is_within_grid)
                                else false;


is_trigger_time <= true when (position.row >= grid_start_row) and 
                   (((position.row = grid_start_row)   and (position.col >= (TO_INTEGER(trigger.t) - 8)) and (position.col <= (TO_INTEGER(trigger.t) + 8))) or
                    ((position.row = grid_start_row+1) and (position.col >= (TO_INTEGER(trigger.t) - 7)) and (position.col <= (TO_INTEGER(trigger.t) + 7))) or
                    ((position.row = grid_start_row+2) and (position.col >= (TO_INTEGER(trigger.t) - 6)) and (position.col <= (TO_INTEGER(trigger.t) + 6))) or
                    ((position.row = grid_start_row+3) and (position.col >= (TO_INTEGER(trigger.t) - 5)) and (position.col <= (TO_INTEGER(trigger.t) + 5))) or
                    ((position.row = grid_start_row+4) and (position.col >= (TO_INTEGER(trigger.t) - 4)) and (position.col <= (TO_INTEGER(trigger.t) + 4))) or
                    ((position.row = grid_start_row+5) and (position.col >= (TO_INTEGER(trigger.t) - 3)) and (position.col <= (TO_INTEGER(trigger.t) + 3))) or
                    ((position.row = grid_start_row+6) and (position.col >= (TO_INTEGER(trigger.t) - 2)) and (position.col <= (TO_INTEGER(trigger.t) + 2))) or
                    ((position.row = grid_start_row+7) and (position.col >= (TO_INTEGER(trigger.t) - 1)) and (position.col <= (TO_INTEGER(trigger.t) + 1))) or
                    ((position.row = grid_start_row+8) and  (TO_INTEGER(trigger.t) = position.col)))
                    else false;
                   
is_trigger_volt <= true when (position.col >= grid_start_col) and 
                   (((position.col = grid_start_col)   and (position.row >= (TO_INTEGER(trigger.v) - 8)) and (position.row <= (TO_INTEGER(trigger.v) + 8))) or
                    ((position.col = grid_start_col+1) and (position.row >= (TO_INTEGER(trigger.v) - 7)) and (position.row <= (TO_INTEGER(trigger.v) + 7))) or
                    ((position.col = grid_start_col+2) and (position.row >= (TO_INTEGER(trigger.v) - 6)) and (position.row <= (TO_INTEGER(trigger.v) + 6))) or
                    ((position.col = grid_start_col+3) and (position.row >= (TO_INTEGER(trigger.v) - 5)) and (position.row <= (TO_INTEGER(trigger.v) + 5))) or
                    ((position.col = grid_start_col+4) and (position.row >= (TO_INTEGER(trigger.v) - 4)) and (position.row <= (TO_INTEGER(trigger.v) + 4))) or
                    ((position.col = grid_start_col+5) and (position.row >= (TO_INTEGER(trigger.v) - 3)) and (position.row <= (TO_INTEGER(trigger.v) + 3))) or
                    ((position.col = grid_start_col+6) and (position.row >= (TO_INTEGER(trigger.v) - 2)) and (position.row <= (TO_INTEGER(trigger.v) + 2))) or
                    ((position.col = grid_start_col+7) and (position.row >= (TO_INTEGER(trigger.v) - 1)) and (position.row <= (TO_INTEGER(trigger.v) + 1))) or
                    ((position.col = grid_start_col+8) and  (TO_INTEGER(trigger.v) = position.row)))
                    else false;

is_ch1_line     <= true when (ch1.active = '1')and (ch1.en = '1' ) and is_within_grid else false;
is_ch2_line     <= true when (ch2.active = '1') and (ch2.en = '1') and is_within_grid else false;


-- Use your booleans to choose the color
color <=        trigger_color when (is_trigger_time or is_trigger_volt) else
                ch1_color when (is_ch1_line) else
                ch2_color when (is_ch2_line) else
                grid_color when (is_vertical_gridline or is_horizontal_gridline) else
                grid_color when (is_vertical_hash or is_horizontal_hash) else
                background_color;                 
                               
end color_mapper_arch;
