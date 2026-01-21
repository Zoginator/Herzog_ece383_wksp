----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/14/2026 08:38:36 PM
-- Design Name: 
-- Module Name: hw4_tb - Behavioral
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

entity hw4_tb is
--  Port ( );
end hw4_tb;

architecture Behavioral of hw4_tb is

    component counter
    generic (
           num_bits : integer := 4;
           max_value : integer := 9
    );
    port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           ctrl : in STD_LOGIC;
           roll : out STD_LOGIC;
           Q : out unsigned (num_bits-1 downto 0));
    end component;
    
    signal w_carry : std_logic;
    signal i_ctrl : std_logic;
    signal i_reset : std_logic;
    signal Q0 : unsigned (3 downto 0);
    signal Q1 : unsigned (3 downto 0);
    signal i_clk : std_logic;
    
    constant k_clk_period : time := 20 ns;

begin

    counter_1s : counter
    port map(
        clk     => i_clk,
        reset_n => i_reset,
        ctrl    => i_ctrl,
        roll    => w_carry,
        Q       => Q0
    );
    
    counter_10s : counter
    port map(
        clk     => i_clk,
        reset_n => i_reset,
        ctrl    => w_carry,
        --roll    => ,
        Q       => Q1
    );
    
    --w_carry <= '1' when (Q0 = 9 and i_ctrl = '1')
                --else '0';
    
    -- Clock Process ------------------------------------
	clk_process : process
	begin
		i_clk <= '0';
		wait for k_clk_period/2;
		
		i_clk <= '1';
		wait for k_clk_period/2;
	end process clk_process;
	
	
	test_process : process
	begin
	wait until falling_edge(i_clk);
	i_reset <= '0'; 
	wait for k_clk_period;
	--count up mode
	i_reset <= '1'; i_ctrl <= '1';
	wait for k_clk_period*4;
	
	--hold at 4 for 1 cycle:
	i_ctrl <= '0';
	wait for k_clk_period;
	i_ctrl <= '1';
	
	wait for k_clk_period*10;
	
	--hold at 14
	i_ctrl <= '0';
	wait for k_clk_period;
	i_ctrl <= '1';
	
	--reset to 0
	i_reset <= '0'; 
	
	wait;
	end process;

end Behavioral;
