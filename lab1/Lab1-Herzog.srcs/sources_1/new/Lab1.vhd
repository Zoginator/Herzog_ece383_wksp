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

    constant CENTER : integer := 0;
    constant DOWN : integer := 1;
    constant LEFT : integer := 2;
    constant RIGHT : integer := 3;
    constant UP : integer := 4;

    signal trigger: trigger_t;
	signal pixel: pixel_t;
	signal ch1, ch2: channel_t;
	signal time_trigger_value, volt_trigger_value : signed(10 downto 0);
begin
   
-- Add numeric steppers for time and voltage trigger
    stepper_1 : numeric_stepper port map(
        clk     => clk,
        reset_n => reset,  
        en      => btn,
        up      
        down    
        q       => volt_trigger_value;
    );
    
    stepper_2 : numeric_stepper port map(
        clk     => clk,
        reset_n => reset,  
        en      => btn,
        up      
        down    
        q       => volt_trigger_value;
    );
-- Assign trigger.t and trigger.v
       	
-- Instantiate video
 
-- Determine if ch1 and or ch2 are active

-- Connect board hardware to signals
begin


end structure;
