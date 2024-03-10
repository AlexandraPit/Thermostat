
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity Sim_unit is
Port (HEAT: in std_logic;
RESET: in std_logic;
Temp_out:out std_logic_vector(4 downto 0);
clk: in std_logic;
led: out std_logic);

end Sim_unit;

architecture Behavioral of Sim_unit is

signal count:std_logic_vector(1 downto 0):="00";
signal temp: std_logic_vector(4 downto 0);
signal a,b: std_logic_vector(4 downto 0);

begin
a<="00000";
b<="11111";
process(clk, reset)
begin
if (reset='0') then
		temp<="00101";
		end if;
if(rising_edge(clk)) then
	if (HEAT='1') then
		if (count = "10") then
			if (temp < b)then
			temp <= std_logic_vector( unsigned(temp) + 1 );
			end if;
		end if;
	elsif (count="10") then
			if (temp > a) then
			temp<=std_logic_vector(unsigned(temp)-1);
			end if;
end if;
end if;

end process;

process(clk)
begin
if(rising_edge(clk)) then
if(count="10")then
count<="00";
else
count<=std_logic_vector( unsigned(count) + 1 );
end if;
end if;
end process;


led<=HEAT;
Temp_out <= temp;

end Behavioral;
