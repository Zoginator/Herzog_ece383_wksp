----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/13/2026 08:46:47 PM
-- Design Name: 
-- Module Name: hw3_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hw3_tb is
--  Port ( );
end hw3_tb;

architecture Behavioral of hw3_tb is

    component hw3
    Port ( d : in unsigned(7 downto 0);
           h : out STD_LOGIC);
    end component;
    
    signal in_num : unsigned(7 downto 0);
    signal o_div : STD_LOGIC;
    
begin

    uut : hw3 PORT MAP(
        d   => in_num,
        h   => o_div);

test_process : process
    begin
    
     in_num <= "00000000"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "00010001"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "00011000"; wait for 10 ns;
        assert o_div = '0' severity failure;
     in_num <= "11000100"; wait for 10 ns;
        assert o_div = '0' severity failure;
     in_num <= "00110011"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "01000100"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "01010101"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "10001000"; wait for 10 ns;
        assert o_div = '1' severity failure;
     in_num <= "11111111"; wait for 10 ns;
        assert o_div = '1' severity failure;
    
    wait;
    end process;
end Behavioral;
