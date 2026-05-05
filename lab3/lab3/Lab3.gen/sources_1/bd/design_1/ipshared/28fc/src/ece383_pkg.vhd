----------------------------------------------------------------------------------
-- Lt Col James Trimble, 16 Jan 2025
-- This package is designed to house types/records, constants, functions, and components that you want to reuse.
-- Signals cannot be used here and variables are not recommended.
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ece383_pkg is
  --= SUBTYPES/RECORDS =--
  subtype color_t is std_logic_vector(23 downto 0);
  
  -- Holds a location
  type coordinate_t is record
       row: unsigned (9 downto 0);
       col: unsigned (9 downto 0);
  end record;
  
  -- Holds a pixel's location and color
  type pixel_t is record
        coordinate: coordinate_t;
        color: color_t;
  end record;
    
  -- Holds the h_sync, v_sync, blank, and r,g,b signals for a VGA display
  type vga_t is record
        hsync : std_logic;
        vsync : std_logic;
        blank : std_logic;
  end record;
  
  -- Used to track the time and voltage locations for triggering
  type trigger_t is record
        t: unsigned(10 downto 0);
        v: unsigned(10 downto 0);
  end record;
  
  -- An input channel to be processed/displayed
  type channel_t is record
    active: std_logic;
    en: std_logic;
  end record;
  
  --= CONSTANTS ==-
  constant WHITE : color_t := x"FFFFFF";
  constant BLACK : color_t := x"000000";
  constant RED : color_t := x"FF0000";
  constant GREEN : color_t := x"00940d";
  constant BLUE : color_t := x"0000FF";
  constant YELLOW : color_t := x"FFFE0E";
  constant BEIGE : color_t := x"F5F5DC";
  constant GRAY : color_t := x"AAAAAA";
  constant D_GREEN : color_t := x"013220";
  
  
  --= COMPONENTS =--
  -- This is the general purpose counter from HW4.  ctrl=1 for count up mode, 0 for hold.
  component counter is
    generic (
      num_bits  : integer := 4;
      max_value : integer := 9
    );
    port ( clk : in std_logic;
           reset_n : in std_logic;
           ctrl : in std_logic;
           roll : out std_logic;
           Q : out unsigned (num_bits-1 downto 0));
  end component;

  -- The num_stepper takes input from a button and increments/decrements its register by delta based on the button presses
  component numeric_stepper is
  generic (
    num_bits  : integer := 8;
    max_value : integer := 127;
    min_value : integer := -128;
    delta     : integer := 10
  );
  port (
    clk     : in  std_logic;
    reset_n : in  std_logic;                    -- active-low synchronous reset
    en      : in  std_logic;                    -- enable
    up      : in  std_logic;                    -- increment on rising edge
    down    : in  std_logic;                    -- decrement on rising edge
    q       : out signed(num_bits-1 downto 0)   -- signed output
  );
  end component;
  
  -- Generates the signals needed for VGA video  
  component vga_signal_generator is
    port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           position: out coordinate_t;
           vga : out vga_t);
    end component;			
			
   -- Maps the pixel location (row,col) to a color based on the location, triggers, and channel values.
   component color_mapper is
   Port ( color : out color_t;
           position: in coordinate_t;
           BRAM_pos : out std_logic_vector(13 downto 0);
		   level_map: in std_logic_vector(3 downto 0); -- BRAM interfacce port
		   NES_buttons : STD_LOGIC_VECTOR(7 downto 0);
		   ball_pos: in std_logic_vector(15 downto 0);
		   mouse_pos: in std_logic_vector(15 downto 0);
		   level_select: in std_logic_vector(3 downto 0);
		   show_win : in std_logic);		
   end component;
   
   -- Holds the pixel clock, VGA component, and DVID (HDMI OUT)
   component video is
     port (  clk : in  STD_LOGIC;
            reset_n : in  STD_LOGIC;
            tmds : out  STD_LOGIC_VECTOR (3 downto 0);
            tmdsb : out  STD_LOGIC_VECTOR (3 downto 0);
            position: out coordinate_t;
            BRAM_pos : out std_logic_vector(13 downto 0);
            BRAM_in : in STD_LOGIC_VECTOR (3 downto 0);
            NES_buttons : STD_LOGIC_VECTOR(7 downto 0);
            ball_pos: in std_logic_vector(15 downto 0);
		    mouse_pos: in std_logic_vector(15 downto 0);
		    level_select: in std_logic_vector(3 downto 0);
		    show_win : in std_logic);
	end component;
	
	-------- LEVEL BRAM COMPONENT DECLARATIONS ----------------	  

component BRAM_Level_Selector is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           level_sel : in STD_LOGIC_VECTOR (3 downto 0);
           position : in STD_LOGIC_VECTOR(13 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component level0_BRAM_Pair is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           position : in STD_LOGIC_VECTOR(13 downto 0);
           data_out : out STD_LOGIC_VECTOR(3 downto 0));
end component;

component level1_BRAM_Pair is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           position : in STD_LOGIC_VECTOR(13 downto 0);
           data_out : out STD_LOGIC_VECTOR(3 downto 0));
end component;
	
  
  --= FUNCTIONS ==-
  function Get_Red(rgb : std_logic_vector(23 downto 0)) return std_logic_vector;
  function Get_Green(rgb : std_logic_vector(23 downto 0)) return std_logic_vector;
  function Get_Blue(rgb : std_logic_vector(23 downto 0)) return std_logic_vector;
  function coords_to_BRAM_address(coord: coordinate_t) return STD_LOGIC_VECTOR;
  function PS2_to_position(PS2_bytes : std_logic_vector(23 downto 0); 
                           last_pos : std_logic_vector(15 downto 0)) return std_logic_vector;
  
  
end package ece383_pkg;

package body ece383_pkg is
  -- Usually empty for component-only packages.
  -- (Package bodies are for functions/procedures/constants needing implementation.)

  --= FUNCTIONS =--
  -- Function to extract the red component
  function Get_Red(rgb : std_logic_vector(23 downto 0)) return std_logic_vector is
  begin
      return rgb(23 downto 16); -- Red slice
  end function;
  
  -- Function to extract the green component
  function Get_Green(rgb : std_logic_vector(23 downto 0)) return std_logic_vector is
  begin
      return rgb(15 downto 8); -- Green slice
  end function;
  
  -- Function to extract the blue component
  function Get_Blue(rgb : std_logic_vector(23 downto 0)) return std_logic_vector is
  begin
      return rgb(7 downto 0); -- Blue slice
  end function;
  
   -- converts a coordinate type to a 13 bit number for BRAM address
 function coords_to_BRAM_address(coord: coordinate_t) return STD_LOGIC_VECTOR is
    variable col : unsigned(9 downto 0);
    variable row : unsigned(9 downto 0);
    variable mult_res : unsigned(17 downto 0);
    variable final_res : unsigned(17 downto 0);
    variable trunc_res : std_logic_vector(13 downto 0);
 begin
    col := unsigned(coord.col);
    row := unsigned(coord.row);
    row := shift_right(row,2);
    mult_res := row * to_unsigned(120,8);
    final_res := mult_res + ("00000000" & col(9 downto 2));
    trunc_res := std_logic_vector(final_res(13 downto 0));
    return trunc_res;
 end function;
 
  -- converts PS2 mouse output into a 20 bit coordinate value
  function PS2_to_position(PS2_bytes : std_logic_vector(23 downto 0);
                           last_pos : std_logic_vector(15 downto 0)) return std_logic_vector is
    variable del_x : signed(8 downto 0);
    variable del_y : signed(8 downto 0);
    variable last_x: signed(8 downto 0);
    variable last_y: signed(8 downto 0);
    variable new_x: signed(8 downto 0);
    variable new_y: signed(8 downto 0);
    variable new_pos : std_logic_vector(15 downto 0);
  begin
    del_x := signed(PS2_bytes(20) & PS2_bytes(15 downto 8)); 
    del_y := signed(PS2_bytes(21) & PS2_bytes(7 downto 0)); 
    last_x := signed('0' & last_pos(7 downto 0));
    last_y := signed('0' & last_pos(15 downto 8));
    new_x := last_x + shift_right(del_x,1); -- scaling down the delta while preserving sign
    if (new_x(8) = '1') then new_x := to_signed(0,9); 
    elsif (new_x > 119) then new_x := to_signed(119,9); 
    end if;
    new_y := last_y - shift_right(del_y,1);
    if (new_y(8) = '1') then new_y := to_signed(0,9); 
    elsif (new_y > 119) then new_y := to_signed(119,9); 
    end if;
    new_pos := std_logic_vector(new_y(7 downto 0) & new_x(7 downto 0));
    return new_pos;
  end function;

end package body ece383_pkg;