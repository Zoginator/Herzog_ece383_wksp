----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/06/2026 09:24:02 PM
-- Design Name: 
-- Module Name: P_encoder - Behavioral
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

entity P_encoder is
    Port ( I3 : in STD_LOGIC;
           I2 : in STD_LOGIC;
           I1 : in STD_LOGIC;
           I0 : in STD_LOGIC;
           O1 : out STD_LOGIC;
           O0 : out STD_LOGIC);
end P_encoder;

architecture Behavioral of P_encoder is

begin

    O1 <= I3 or I2;
    O0 <= (not I3 and not I2 and I1) or I3;
    
end Behavioral;
