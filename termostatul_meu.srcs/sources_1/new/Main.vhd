
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Main is
Port (
clk: in std_logic;
RESET: in std_logic; 
Set_Hour: in std_logic; 
B_up, B_down, B_ok: in std_logic;

LED_heat:out std_logic;
Anode_activator: out std_logic_vector (7 downto 0);
LED_digit: out std_logic_vector(6 downto 0));
end Main;

architecture Behavioral of Main is

component digital_clockv2 is
port ( 
 	clk_ceas: in std_logic; 
 	rst_n: in std_logic; 

    H_out1_bin: out std_logic_vector(3 downto 0);
    H_out0_bin: out std_logic_vector(3 downto 0);
    M_out1_bin: out std_logic_vector(3 downto 0);
    M_out0_bin: out std_logic_vector(3 downto 0)
);
end component;

component MEMORIE_RAM is
	port(
	A_RAM_r: in std_logic_vector(4 downto 0);
	CS_RAM, WE: in std_logic;
	I_RAM: in std_logic_vector(9 downto 0); -- INTRARE || first 5 bits = min temeperature || last 5 bits = max temperature
	D_RAM: out std_logic_vector(9 downto  0); --IESIRE
	ram_clk: in std_logic;
	A_WRITE:in std_logic_vector(4 downto 0));
end component;

component Set_Temp is
Port (

Set_hour: in std_logic;
Ora_5biti: in std_logic_vector(4 downto 0);
T_RAM: in std_logic_vector(9 downto 0);
reset:in std_logic;
Hour_out: out std_logic_vector(4 downto 0);
T_out: out std_logic_vector(9 downto 0);
button_up, button_down, button_ok:in std_logic);
end component;

component Sim_unit is
Port (HEAT: in std_logic;
RESET: in std_logic;
Temp_out:out std_logic_vector(4 downto 0);
clk: in std_logic;
led: out std_logic);

end component;

component Thermostat is
    port(T_RAM: in std_logic_vector(9 downto 0);
    RESET: in std_logic;
    TREAL: in std_logic_vector(4 downto 0);
    HEAT: out std_logic;
    clk: in std_logic);
    
end component;

component Tram_to_ssd is
 Port (
 T_ram: in std_logic_vector(9 downto 0 );
 Tmin_out: out std_logic_vector(4 downto 0);
 Tmax_out: out std_logic_vector(4 downto 0));

end component;

component TransfORA_AdresaRAM is
	port( ORA_unit: in std_logic_vector(3 downto 0);
	ORA_zeci: in std_logic_vector(3 downto 0);
	ORA_5BIT: out std_logic_vector(4 downto 0));
end component;


component seven_segment_display is
 Port ( clock_100Mhz : in STD_LOGIC;
	
	       Hin_zeci: in std_logic_vector(3 downto 0);
		   Hin_unitati: in std_logic_vector(3 downto 0);
		   H_toset: in std_logic_vector(4 downto 0);
		   Min_zeci: in	std_logic_vector(3 downto 0);
		   Min_unitati: in std_logic_vector(3 downto 0);
		   Temp: in std_logic_vector(4 downto 0);
		   Tmin:in std_logic_vector(4 downto 0);
		   Tmax:in std_logic_vector(4 downto 0);
		   Set_hour:in std_logic;
   
	       reset : in STD_LOGIC; 
           Anode_Activate : out STD_LOGIC_VECTOR (7 downto 0);   -- 6 Anode signals
           LED_out : out STD_LOGIC_VECTOR (6 downto 0));     -- Cathode patterns of 7-segment display
end component;

component transf5to4 is
	port(Biti_5: in std_logic_vector(4 downto 0);
	Zeci: out std_logic_vector(3 downto 0);
	Unitati: out std_logic_vector(3 downto 0));
end component;
component clk_div is
port (
   clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           divided_clk : out  STD_LOGIC
  );
end component;
component Debouncer is
port(button: IN std_logic;
	clk: IN std_logic;
	button_debounced: OUT std_logic);
END component;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Inceput semnale ceas
signal ORA_UNIT: std_logic_vector(3 downto 0); --SEMNAL ORA UNITATI
signal ORA_ZECI: std_logic_vector(3 downto 0); --SEMNAL ORA ZECI
signal MINUTE_UNIT: std_logic_vector(3 downto 0); --SEMANL MINUTE UNITATI
signal MINUTE_ZECI: std_logic_vector( 3 downto 0); --SEMNAL MINUTE ZECI
--Sfarsit Semanle Ceas

--inceput clk_div
signal clk_1s : std_logic;
--sfarsit 

--Inceput semnal ORA5BIT
signal ORA_ADRESA_RAM: std_logic_vector(4 downto 0);
--Sfarsit semnal ora5bit

--Semnal RAM
signal Iesire_ram:std_logic_vector(9 downto 0);
--sfarsit

--semnal thermostat
signal heat_sig: std_logic;
--sfarsit

--semnal sim_unit
signal temp_us: std_logic_vector(4 downto 0);
signal led:std_logic;
--sfarsit

--semnal set_temp
signal hour_to_set :std_logic_vector(4 downto 0);
signal temp_out :std_logic_vector(9 downto 0);

--sfarsit

--semnal tram_to_ssd
signal Tminim: std_logic_vector(4 downto 0);
signal Tmaxim : std_logic_vector(4 downto 0);
signal Tmin_a:std_logic_vector(4 downto 0);
signal Tmax_a:std_logic_vector(4 downto 0);
--sfarsit

--semnal 5to4
--sfarsit
--signal debouncer
signal db_up:std_logic;
signal db_down:std_logic;
signal db_ok:std_logic;


begin
U1:clk_div port map (clk=>clk,
           rst=>reset,
           divided_clk=>clk_1s);
U2: digital_clockv2 port map( 
                              H_out1_bin => ORA_ZECI,
                              H_out0_bin => ORA_UNIT,
                              M_out1_bin => MINUTE_ZECI,
                              M_out0_bin => MINUTE_UNIT,
                              clk_ceas => clk_1s,
                              rst_n =>RESET);
U3:TransfORA_AdresaRAM port map(
                                ORA_unit => ORA_UNIT,
                                ORA_zeci => ORA_ZECI,
                                ORA_5BIT => ORA_ADRESA_RAM);
U4:Memorie_RAM port map(
                        A_RAM_r=>ORA_ADRESA_RAM,
                        CS_RAM=>RESET,
                        WE=>Set_hour,
                        I_RAM=>temp_out,
                        D_RAM=>Iesire_RAM,
                        ram_clk=>clk,
                        A_WRITE=>hour_to_set);
U5:debouncer port map(
    button=>b_up,
	clk=>clk,
	button_debounced=>db_up);
U6:debouncer port map(
    button=>b_down,
	clk=>clk,
	button_debounced=>db_down);
U7:debouncer port map(
    button=>b_ok,
	clk=>clk,
	button_debounced=>db_ok);
U8:Set_temp port map( Set_hour=>Set_hour,
                      Ora_5biti=>ORA_ADRESA_RAM,
                      T_RAM=>Iesire_ram,
                      reset=>RESET,
                      Hour_out=>hour_to_set,
                      T_out=>temp_out,
                      button_up=>db_up,
                      button_down=>db_down,
                      button_ok=>db_ok);
                      

U9:Sim_unit port map (HEAT=>heat_sig,
                      RESET=>RESET,
                      Temp_out=>temp_us,
                      clk=>clk_1s,
                      led=>led_heat);
                      
U10:thermostat port map(T_RAM=>Iesire_ram,
                       RESET=>RESET,
                       TREAL=>temp_us,
                       HEAT=>heat_sig,
                       clk=>clk);

U11:Tram_to_ssd port map(T_ram=>temp_out,  Tmin_out=>Tmin_a, Tmax_out=>tmax_a);


U12:seven_segment_display port map(clock_100Mhz=>clk,
	
	       Hin_zeci=>ORA_zeci,
		   Hin_unitati=>ORA_unit,
		   H_toset=>hour_to_set,
		   Min_zeci=>MINute_zeci,
		   Min_unitati=>MInute_unit,
		   Temp=>temp_us,
		   Tmin=>Tmin_a,
		   Tmax=>Tmax_a,
		   Set_hour=>set_hour,
   
	       
	       reset=>RESET,
           Anode_Activate=>Anode_activator, 
           LED_out=>LED_digit);                         

end Behavioral;
