 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Debouncer IS
PORT (
	button: IN std_logic;
	clk: IN std_logic;
	button_debounced: OUT std_logic);
END Debouncer;



architecture Behavioral of debouncer is
signal counter: std_logic_vector(15 downto 0):=(others=>'0');
signal Q1,Q2,Q3: std_logic;
begin
button_debounced<=not(Q3) and Q2;
process(clk)
begin

if clk='1' and clk'event then 
    counter<=counter+1;
    if counter="111111111111" then
        Q1<=button;
    end if;
    Q2<=Q1;
    Q3<=Q2;
end if;
end process;
 
end Behavioral;
