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
           BRAM_pos : out std_logic_vector(13 downto 0);
		   level_map: in std_logic_vector(3 downto 0); -- BRAM interfacce port
		   NES_buttons : in STD_LOGIC_VECTOR(7 downto 0);
		   ball_pos: in std_logic_vector(15 downto 0);
		   mouse_pos: in std_logic_vector(15 downto 0);
		   level_select: in std_logic_vector(3 downto 0);
		   show_win : in std_logic);
end color_mapper;

architecture color_mapper_arch of color_mapper is

signal BALL_COLOR : color_t := YELLOW;
signal CURSOR_COLOR : color_t := RED;
signal NES_PRESSED : color_t := BLUE; 
signal NES_OFF : color_t := RED;
signal WIN_bkgd : color_t := BLACK;
signal WIN_text : color_t := YELLOW;  
-- Add other colors you want to use here

signal BRAM_color_code : color_t;

-- NES button indicators
signal NES_right, NES_left, NES_up, NES_down, NES_start, NES_select, NES_B, NES_A : std_logic;
signal is_cursor, is_ball, is_win_bkgd, is_win_text : std_logic;

signal cursor_x, cursor_y, ball_x, ball_y : unsigned(9 downto 0);

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
ball_x <= unsigned("00" & ball_pos(7 downto 0));
ball_Y <= unsigned("00" & ball_pos(15 downto 8));

is_cursor <= '1' when ((position.row/4 = cursor_y) and (position.col/4 = cursor_x)) else
             '0';
is_ball <= '1' when ((position.row/4 = ball_y) and (position.col/4 = ball_x)) else
           '0';  
           
--win message
is_win_bkgd <= '1' when (
                ((position.col >= 180) and (position.col < 300)) and
                ((position.row >= 120) and (position.row < 180)))
               else '0';
               
is_win_text <= '1' when (
                ((position.col = 197) and (position.row >= 135 and position.row <= 167)) or
                ((position.col = 222) and (position.row >= 135 and position.row <= 167)) or
                ((position.col = 240) and (position.row >= 135 and position.row <= 167)) or
                ((position.col = 258) and (position.row >= 135 and position.row <= 167)) or
                ((position.col = 275) and (position.row >= 135 and position.row <= 167)) or
                ((position.col >= 229 and position.col <= 251) and (position.row = 135)) or
                ((position.col >= 229 and position.col <= 251) and (position.row = 167)) or
                ((position.col = 198 or position.col = 221) and (position.row = 166)) or
                ((position.col = 199 or position.col = 220) and (position.row = 165)) or 
                ((position.col = 200 or position.col = 219) and (position.row = 164)) or 
                ((position.col = 201 or position.col = 218) and (position.row = 163)) or 
                ((position.col = 202 or position.col = 217) and (position.row = 162)) or
                ((position.col = 203 or position.col = 216) and (position.row = 161)) or 
                ((position.col = 204 or position.col = 215) and (position.row = 160)) or 
                ((position.col = 205 or position.col = 214) and (position.row = 159)) or 
                ((position.col = 206 or position.col = 213) and (position.row = 158)) or 
                ((position.col = 207 or position.col = 212) and (position.row = 157)) or 
                ((position.col = 208 or position.col = 211) and (position.row = 156)) or 
                ((position.col = 209 or position.col = 210) and (position.row = 155)) or
                ((position.col = 259) and (position.row = 136 or position.row = 137)) or
                ((position.col = 260) and (position.row = 138 or position.row = 139)) or 
                ((position.col = 261) and (position.row = 140 or position.row = 141)) or 
                ((position.col = 262) and (position.row = 142 or position.row = 143)) or 
                ((position.col = 263) and (position.row = 144 or position.row = 145)) or 
                ((position.col = 264) and (position.row = 146 or position.row = 147)) or 
                ((position.col = 265) and (position.row = 148 or position.row = 149)) or 
                ((position.col = 266) and (position.row = 150 or position.row = 151)) or 
                ((position.col = 267) and (position.row = 152 or position.row = 153)) or 
                ((position.col = 268) and (position.row = 154 or position.row = 155)) or 
                ((position.col = 269) and (position.row = 156 or position.row = 157)) or 
                ((position.col = 270) and (position.row = 158 or position.row = 159)) or 
                ((position.col = 271) and (position.row = 160 or position.row = 161)) or 
                ((position.col = 272) and (position.row = 162 or position.row = 163)) or 
                ((position.col = 273) and (position.row = 164 or position.row = 165)) or 
                ((position.col = 274) and (position.row = 166 or position.row = 167)))
                 else '0';             
                                                                                                                         
-- coordinate to BRAM position converter
BRAM_pos <= coords_to_BRAM_address(position);

-- BRAM color decoder
BRAM_COLOR_CODE <= WHITE when (level_map = "0000") else
                   BLACK when (level_map = "0001") else
                   GRAY  when (level_map = "0010") else
                   GREEN when (level_map = "0011") else
                   D_GREEN when (level_map = "0100") else 
                   BLUE when (level_map = "0101") else
                   RED when  (level_map = "1001") else                     
                   YELLOW;
                   -- add more values post testing
                   
-- Use your booleans to choose the color
color <= CURSOR_COLOR when (is_cursor) else
         WIN_text when (is_win_text and show_win) else
         WIN_bkgd when (is_win_bkgd and show_win) else
         BALL_COLOR when (is_ball) else
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
