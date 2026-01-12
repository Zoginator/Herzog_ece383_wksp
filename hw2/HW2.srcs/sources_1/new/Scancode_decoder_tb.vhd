----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/11/2026 07:56:27 PM
-- Design Name: 
-- Module Name: Scancode_decoder_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Scancode_decoder_tb is
--  Port ( );
end Scancode_decoder_tb;

architecture Behavioral of Scancode_decoder_tb is

    component scancode_decoder
    port(   scancode : in STD_LOGIC_VECTOR (7 downto 0);
            decoded_value : out STD_LOGIC_VECTOR (3 downto 0));
    end component; 
    
    signal s_code: STD_LOGIC_VECTOR (7 downto 0);
    signal o_key: STD_LOGIC_VECTOR (3 downto 0);

begin

    uut: scancode_decoder PORT MAP(
            scancode        => s_code,
            decoded_value   => o_key);    

test_process : process
    begin
    
     s_code <= x"45"; wait for 10 ns;
        assert o_key = "0000" severity failure;
     s_code <= x"16"; wait for 10 ns;
        assert o_key = "0001" severity failure;
     s_code <= x"1E"; wait for 10 ns;
        assert o_key = "0010" severity failure;
     s_code <= x"26"; wait for 10 ns;
        assert o_key = "0011" severity failure;
     s_code <= x"25"; wait for 10 ns;
        assert o_key = "0100" severity failure;
     s_code <= x"2E"; wait for 10 ns;
        assert o_key = "0101" severity failure;
     s_code <= x"36"; wait for 10 ns;
        assert o_key = "0110" severity failure;
     s_code <= x"3D"; wait for 10 ns;
        assert o_key = "0111" severity failure;
     s_code <= x"3E"; wait for 10 ns;
        assert o_key = "1000" severity failure;
     s_code <= x"46"; wait for 10 ns;
        assert o_key = "1001" severity failure;
    
    wait;
    end process;
end behavioral;
