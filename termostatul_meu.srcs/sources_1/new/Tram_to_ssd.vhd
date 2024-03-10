

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity Tram_to_ssd is
 Port (
 T_ram: in std_logic_vector(9 downto 0 );
 Tmin_out: out std_logic_vector(4 downto 0);
 Tmax_out: out std_logic_vector(4 downto 0));

end Tram_to_ssd;

architecture Behavioral of Tram_to_ssd is
signal Tmin, Tmax: std_logic_vector (4 downto 0);
begin
process(T_ram)
begin
Tmax <= T_RAM(4 downto 0);
Tmin <= T_RAM(9 downto 5);
end process;
Tmin_out<=Tmin;
Tmax_out<=Tmax;
end Behavioral;
