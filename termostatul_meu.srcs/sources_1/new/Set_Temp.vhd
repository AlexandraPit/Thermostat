
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity Set_Temp is
Port (

Set_hour: in std_logic;
Ora_5biti: in std_logic_vector(4 downto 0);
T_RAM: in std_logic_vector(9 downto 0);
reset:in std_logic;
Hour_out: out std_logic_vector(4 downto 0);
T_out: out std_logic_vector(9 downto 0);
button_up, button_down, button_ok:in std_logic);
end Set_Temp;

architecture Behavioral of Set_Temp is
signal Hours: std_logic_vector(4 downto 0); 
signal Tmin, Tmax: std_logic_vector(4 downto 0); 
signal count:std_logic_vector(1 downto 0):="00";
begin
process(button_up, button_down, reset)
begin

if(reset='0') then
Hours<= Ora_5biti;
Tmax <= T_RAM(4 downto 0);
Tmin <= T_RAM(9 downto 5);
end if;
if (Set_hour='1') then
	
if(count="00") then
	if(button_up = '1' and hours<23) then
		hours <= std_logic_vector( unsigned(hours) + 1 );
	elsif(button_down='1' and hours>0)then
		hours <= std_logic_vector( unsigned(hours) - 1 );
	end if;
elsif(count="01") then
		if(button_up='1') then
			Tmin <= std_logic_vector( unsigned(Tmin) + 1 );
		elsif(button_down='1' ) then
			Tmin <= std_logic_vector( unsigned(Tmin) - 1 );
		end if;
elsif(count="10") then
		if(button_up='1') then
			Tmax <= std_logic_vector( unsigned(Tmax) + 1 );
		elsif(button_down='1') then
			Tmax <= std_logic_vector( unsigned(Tmax) - 1 );
		end if;
end if;
end if;
end process;

process(button_ok)
begin
if(button_ok='1') then
if(count="10") then
count<="00";
else
count<=std_logic_vector( unsigned(count) + 1 );
end if;
end if;
end process;

Hour_out<=Hours;
T_out<=Tmin & Tmax;

end Behavioral;
