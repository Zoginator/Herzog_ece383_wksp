------
-- Lt Col James Trimble, 15 Jan 2025
-- Generates VGA signal with graphics
------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ece383_pkg.ALL;
 
entity vga is
	Port(	clk: in  STD_LOGIC;
			reset_n : in  STD_LOGIC;
			vga : out vga_t;
            pixel : out pixel_t;
			trigger : in trigger_t;
            ch1 : in channel_t;
            ch2 : in channel_t);
end vga;

architecture vga_arch of vga is

    component vga_signal_generator is
        Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           position: out coordinate_t;
           vga : out vga_t);
    end component;
    
    component color_mapper is
        Port ( color : out color_t;
           position: in coordinate_t;
		   trigger : in trigger_t;
           ch1 : in channel_t;
           ch2 : in channel_t);
    end component;
    
        	
begin

inst_vga_signal_generator : vga_signal_generator 
    port map(
        clk         => clk,
        reset_n     => reset_n,
        position    => pixel.coordinate,
        vga         => vga);
        
inst_color_mapper : color_mapper
    port map(
        color       => pixel.color,
        position    => pixel.coordinate,
		trigger     => trigger,
        ch1         => ch1,
        ch2         => ch2);
        

end vga_arch;
