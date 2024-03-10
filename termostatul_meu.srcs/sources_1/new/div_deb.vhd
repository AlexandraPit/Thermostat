LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Clk_Divider IS
--divides from 100 MHz = 100.000.000 Hz to 1 millisecond = 1000 Hz
  PORT (
  
	clock: IN std_logic;
  	divided_clock: OUT std_logic
    );
END Clk_Divider;

ARCHITECTURE TypeArchitecture OF Clk_Divider IS

signal count: INTEGER := 1;

BEGIN

process(clock, count)
begin
	if(rising_edge(clock)) then
		if(count = 100000) then count <= 1;
		else count <= count + 1;
		end if;
	end if;

	if(count <= 50000) then divided_clock <= '0';
	else divided_clock <= '1';
	end if;
		
end process;

END TypeArchitecture;