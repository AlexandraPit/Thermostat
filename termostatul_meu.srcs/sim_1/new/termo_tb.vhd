
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity termo_tb is
--  Port ( );
end entity;
architecture behavioral of termo_tb is
component main is
port ( clk: in std_logic;
RESET: in std_logic; 
Set_Hour: in std_logic; 
B_up, B_down, B_ok: std_logic;

LED_heat:out std_logic;
Anode_activator: out std_logic_vector (5 downto 0);
LED_digit: out std_logic_vector(6 downto 0));
end component;

shared variable END_SIM: BOOLEAN := FALSE;
signal RESET,Set_hour,B_up, b_down, b_ok, led_heat, clk: std_logic;
signal Anode_activator: std_logic_vector (5 downto 0);
signAL LED_digit:  std_logic_vector(6 downto 0);
constant CLK_PERIOD: TIME := 20 ns;

begin
uut: main port map (
clk=>clk,
RESET=>reset,
Set_Hour=>set_hour,
B_up=>b_up,
 B_down=>b_down,
  B_ok=>b_ok,

LED_heat=>led_heat,
Anode_activator=>anode_activator,
LED_digit=>led_digit
);
CLK_GENERATOR: process
 begin
 if not END_SIM then
 CLK <= '0';
 wait for CLK_PERIOD / 2;
 CLK <= '1';
 wait for CLK_PERIOD / 2;
 else wait;
 end if;
end process CLK_GENERATOR;

STIMULUS: process
begin
reset<='1';
 set_hour<= '1';
 b_up<='1';
 wait for 210 ns;
 b_up<='0';
 set_hour <= '0';
 wait for 200 ns;
END_SIM := TRUE; 
wait;
end process STIMULUS;


end Behavioral;
