
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Thermostat is
    port(T_RAM: in std_logic_vector(9 downto 0);
    RESET: in std_logic;
    TREAL: in std_logic_vector(4 downto 0);
    HEAT: out std_logic;
    clk: in std_logic);
    
end Thermostat;

architecture Behavioral of Thermostat is
signal TMIN, TMAX, T_REAL : integer;

begin

process(clk, RESET, TREAl,T_RAM)
begin
T_REAL<= to_integer(unsigned(TREAL(4 downto 0)));
TMAX <= to_integer (unsigned(T_RAM(4 downto 0)));
TMIN <= to_integer (unsigned(T_RAM(9 downto 5)));
if (RESET = '0') then
    HEAT <= '0';
elsif (rising_edge(clk)) then
   if(T_REAL < TMIN) then
    HEAT <= '1';
 elsif(T_REAL > TMAX) then
     HEAT<= '0';
     end if;
     end if; 
 end process;
end Behavioral;
