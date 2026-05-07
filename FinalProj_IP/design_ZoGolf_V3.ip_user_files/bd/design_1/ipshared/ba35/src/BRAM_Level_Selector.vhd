----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 01:59:51 PM
-- Design Name: 
-- Module Name: BRAM_Level_Selector - Behavioral
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

entity BRAM_Level_Selector is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           level_sel : in STD_LOGIC_VECTOR (3 downto 0);
           position : in STD_LOGIC_VECTOR(13 downto 0);
           data_out : out STD_LOGIC_VECTOR (3 downto 0));
end BRAM_Level_Selector;

architecture Behavioral of BRAM_Level_Selector is

signal level0_data : STD_LOGIC_VECTOR(3 downto 0);
signal level1_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level2_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level3_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level4_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level5_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level6_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level7_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level8_data : STD_LOGIC_VECTOR(3 downto 0);
--signal level9_data : STD_LOGIC_VECTOR(3 downto 0);


begin

inst_level0 : level0_BRAM_Pair
    port map(
        clk      => clk,
        reset_n  => reset_n,
        position => position,
        data_out => level0_data);

inst_level1 : level1_BRAM_Pair
    port map(
        clk      => clk,
        reset_n  => reset_n,
        position => position,
        data_out => level1_data);

        
            
---- level selector MUX ------

data_out <= level0_data when (level_sel = "0000") else
            level1_data when (level_sel = "0001") else
--            level2_data when (level_sel = "0010") else
--            level3_data when (level_sel = "0011") else
--            level4_data when (level_sel = "0100") else
--            level5_data when (level_sel = "0101") else
--            level6_data when (level_sel = "0110") else
--            level7_data when (level_sel = "0111") else
--            level8_data when (level_sel = "1000") else
--            level9_data when (level_sel = "1001") else
            level0_data;

    

end Behavioral;
