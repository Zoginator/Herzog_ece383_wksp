----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/23/2026 07:10:42 AM
-- Design Name: 
-- Module Name: vga_signal_generator_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_signal_generator_tb is
--  Port ( );
end vga_signal_generator_tb;




architecture Behavioral of vga_signal_generator_tb is
  	

-- test signals
signal tb_clk : std_logic;
signal i_ctrl : std_logic;
signal i_reset : std_logic;
signal tb_pos: coordinate_t;
signal tb_vga : vga_t;

constant k_clk_period : time := 20 ns;

begin

  test_vga_gen : vga_signal_generator port map( 
           clk      => tb_clk,
           reset_n  => i_reset,
           position => tb_pos,
           vga      => tb_vga);

 -- clk process)
 clk_process : process
	begin
		tb_clk <= '0';
		wait for k_clk_period/2;
		
		tb_clk <= '1';
		wait for k_clk_period/2;
	end process clk_process;
	
	
test_process : process
    begin
	wait until falling_edge(tb_clk);
	   i_reset <= '0'; i_ctrl <= '0';
	wait for k_clk_period;
	
	--count up mode
	i_reset <= '1'; i_ctrl <= '1';
	wait; -- for k_clk_period*800;
	
	
	end process;
end Behavioral;
