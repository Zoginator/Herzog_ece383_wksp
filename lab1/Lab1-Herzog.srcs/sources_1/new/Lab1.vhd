----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/21/2026 08:50:36 AM
-- Design Name: 
-- Module Name: Lab1 - Behavioral
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
use work.ece383_pkg.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab1 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           tmds : out STD_LOGIC_VECTOR (3 downto 0);
           tmdsb : out STD_LOGIC_VECTOR (3 downto 0);
           sw : in std_logic_vector (1 downto 0));
end Lab1;

architecture structure of Lab1 is

    constant CENTER : integer := 4;
    constant DOWN : integer := 2;
    constant LEFT : integer := 1;
    constant RIGHT : integer := 3;
    constant UP : integer := 0;

    signal trigger: trigger_t;
	signal pixel: pixel_t;
	signal ch1, ch2: channel_t;
	signal time_trigger_value, volt_trigger_value : signed(10 downto 0);
	--signal w_tmds, w_tmdsb : STD_LOGIC_VECTOR (3 downto 0);
	--signal w_btn : STD_LOGIC_VECTOR (4 downto 0);
	
begin
   
-- Add numeric steppers for time and voltage trigger
    stepper_t : numeric_stepper 
    generic map(
        num_bits  => 11,
        max_value => 300,
        min_value => -300,
        delta     => 5
    )
    port map(
        clk     => clk,
        reset_n => reset,  
        en      => '1',
        up      => btn(RIGHT),
        down    => btn(LEFT),
        q       => time_trigger_value
    );
    
    stepper_v : numeric_stepper 
    generic map(
        num_bits  => 11,
        max_value => 200,
        min_value => -200,
        delta     => 5
    )
    port map(
        clk     => clk,
        reset_n => reset,  
        en      => '1',
        up      => btn(DOWN),
        down    => btn(UP),
        q       => volt_trigger_value
    );
    
-- Assign trigger.t and trigger.v
    trigger.t <= unsigned(time_trigger_value + 320);
    trigger.v <= unsigned(volt_trigger_value + 220);
       	
-- Instantiate video
    video_main : video port map(
            clk     => clk,
            reset_n => reset,
            tmds    => tmds,
            tmdsb   => tmdsb,
            trigger => trigger,
            position => pixel.coordinate,
            ch1     => ch1,
            ch2     => ch2
    );
-- Determine if ch1 and or ch2 are active
ch1.active <= '1' when (pixel.coordinate.row = pixel.coordinate.col) else '0';
ch2.active <= '1' when (pixel.coordinate.row = (440-pixel.coordinate.col)) else '0';

-- Connect board hardware to signals
ch1.en <= sw(0);
ch2.en <= sw(1);
--reset  <= reset_n;

end structure;
