----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 08:14:12 AM
-- Design Name: 
-- Module Name: ZoGolf_DataPath - Behavioral
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

entity ZoGolf_DataPath is
    Port ( 
    clk : in  STD_LOGIC;
	reset_n : in  STD_LOGIC;
	tmds : out STD_LOGIC_VECTOR (3 downto 0);
    tmdsb : out STD_LOGIC_VECTOR (3 downto 0); 
    --NES_buttons : out STD_LOGIC_VECTOR(7 downto 0);
    latch : out STD_LOGIC; --NES
    pulse : out STD_LOGIC; --NES
    data : in STD_LOGIC);  --NES
    --flagQ: out std_logic;   
    --flagClear: in std_logic;
    --sw : out std_logic_vector(1 downto 0));
end ZoGolf_DataPath;



architecture ZoGolf_Datapath_arch of ZoGolf_DataPath is

component NES_Controller is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           buttons : out STD_LOGIC_VECTOR (7 downto 0);
           latch : out STD_LOGIC;
           pulse : out STD_LOGIC;
           data : in STD_LOGIC);
end component;

    signal sw_ready: std_logic;
    signal sw_last_address: std_logic;
    
    signal BRAM_DO : STD_LOGIC_VECTOR(3 downto 0);
    signal BRAM_pos_sel : STD_LOGIC_VECTOR(12 downto 0);
    
    signal w_NES_buttons : STD_LOGIC_VECTOR(7 downto 0);
    
    signal PS2_coord : STD_LOGIC_VECTOR(19 downto 0);
    signal ball_reg : STD_LOGIC_VECTOR(19 downto 0);
    signal level_reg : STD_LOGIC_Vector(3 downto 0);
    
    signal position : coordinate_t;
    
begin

-- logic for the FLAG register
--	process (clk)
--	begin
--    	if (rising_edge(clk)) then
--			if reset_n = '0' then
--				flagQ <= '0';
--		    elsif (sw_ready = '0' and flagClear = '1') then
--		        flagQ <= '0';
--		    elsif (sw_ready = '1' and flagClear = '0') then
--		        flagQ <= '1';
				
--			end if;
--		end if;
--	end process;

	
	video_inst : video port map(
	        clk         => clk,
            reset_n     => reset_n,
            tmds        => tmds,
            tmdsb       => tmdsb,
            position    => position,
            BRAM_pos    => BRAM_pos_sel,
            BRAM_in     => BRAM_DO,
            NES_buttons => w_NES_buttons,
            ball_pos    => ball_reg,
		    mouse_pos   => PS2_coord,
		    level_select => level_reg);
		    
		    
    level_selctor_inst : BRAM_Level_Selector Port map( 
           clk       => clk,
           reset_n   => reset_n,
           level_sel => level_reg,
           position  => BRAM_pos_sel,
           data_out  => BRAM_DO);

-- NES controller 
NES_inst :NES_Controller Port map( 
           clk      => clk,
           reset_n  => reset_n,
           buttons  => w_NES_buttons,
           latch    => latch,
           pulse    => pulse,
           data     => data);

    --sw(0) <= sw_ready;
    --sw(1) <= sw_last_address; --needed?
  
    
    
   --TEMPORARY NULLIFIED PORTS
   --NES_buttons <= w_NES_buttons;
   PS2_coord <= "00000000000000000000";
   ball_reg <= "00000000000000000000";
   level_reg <= "0000";
   
    
end ZoGolf_Datapath_arch;
