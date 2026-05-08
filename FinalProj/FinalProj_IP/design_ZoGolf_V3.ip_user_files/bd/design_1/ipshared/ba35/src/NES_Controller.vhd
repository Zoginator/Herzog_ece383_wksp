----------------------------------------------------------------------------------
-- Engineer: Lt Col James Trimble
-- 
-- Create Date: 03/05/2026 12:48:38 PM
-- Design Name: 
-- Module Name: NES_Controller - NES_Controller_arch
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

entity NES_Controller is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           buttons : out STD_LOGIC_VECTOR (7 downto 0);
           latch : out STD_LOGIC;
           pulse : out STD_LOGIC;
           data : in STD_LOGIC);
end NES_Controller;

architecture NES_Controller_arch of NES_Controller is

signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;

signal       cpu_reset : std_logic;
signal             rdl : std_logic;

signal     int_request : std_logic;

    attribute mark_debug : string;
    attribute keep       : string;
    
    attribute mark_debug of latch : signal is "true";
    attribute keep       of latch : signal is "true";
    
    attribute mark_debug of pulse : signal is "true";
    attribute keep       of pulse : signal is "true";
    
    attribute mark_debug of data : signal is "true";
    attribute keep       of data : signal is "true";

  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

  component NES_Controller_ROM                             
    generic(             C_FAMILY : string := "7S"; 
                C_RAM_SIZE_KWORDS : integer := 2;
             C_JTAG_LOADER_ENABLE : integer := 1);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;


--
-- Declaration of the default Program Memory recommended for development.
--
-- The name of this component should match the name of your PSM file.
--


begin

 processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
                       
  program_rom: NES_Controller_ROM                     --Name to match your PSM file
    generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);                       
                       
  input_ports: process(clk)
  

    
  begin
    if clk'event and clk = '1' then

      case port_id(2 downto 0) is

        -- Read input_port_a at port address 00 hex
--        when "000" =>    in_port <= sw;

--        -- Read input_port_b at port address 01 hex
--        when "001" =>    in_port <= x"00";

--        -- Read input_port_c at port address 02 hex
--        when "10" =>    in_port <= input_port_c;

--        -- Read input_port_d at port address 03 hex
--        when "11" =>    in_port <= input_port_d;

        -- Read input_port_b at port address 01 hex
        when "100" =>    in_port <= "0000000" & not data;
        
        -- To ensure minimum logic implementation when defining a multiplexer always
        -- use don't care for any of the unused cases (although there are none in this 
        -- example).

        when others =>    in_port <= x"00";  

      end case;

    end if;

  end process input_ports;
  
    output_ports: process(clk)
  begin

    if clk'event and clk = '1' then

      -- 'write_strobe' is used to qualify all writes to general output ports.
      if write_strobe = '1' then

        -- Write to output_port_w at port address 01 hex
        if port_id(2 downto 0) = "001" then
          buttons <= out_port;
        end if;
        
        -- LATCH
        if port_id(2 downto 0) = "010" then
          latch <= out_port(0);
        end if;
        
        -- Write to output_port_w at port address 03 hex
        if port_id(2 downto 0) = "011" then
          pulse <= out_port(0);
        end if;

--        -- Write to output_port_x at port address 02 hex
--        if port_id(1) = '1' then
--          output_port_x <= out_port;
--        end if;

--        -- Write to output_port_y at port address 04 hex
--        if port_id(2) = '1' then
--          output_port_y <= out_port;
--        end if;

--        -- Write to output_port_z at port address 08 hex
--        if port_id(3) = '1' then
--          output_port_z <= out_port;
--        end if;

      end if;

    end if; 

  end process output_ports;
                     

end NES_Controller_arch;
