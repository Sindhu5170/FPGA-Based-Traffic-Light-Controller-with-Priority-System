library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_light_tb is
end traffic_light_tb;

architecture Behavioral of traffic_light_tb is

signal clk       : STD_LOGIC := '0';
signal reset     : STD_LOGIC := '0';
signal emergency : STD_LOGIC := '0';

signal north_red, north_yel, north_grn : STD_LOGIC;
signal east_red, east_yel, east_grn    : STD_LOGIC;

begin

uut: entity work.traffic_light
port map(
    clk => clk,
    reset => reset,
    emergency => emergency,
    north_red => north_red,
    north_yel => north_yel,
    north_grn => north_grn,
    east_red => east_red,
    east_yel => east_yel,
    east_grn => east_grn
);

-- Clock generation
clk_process : process
begin
    while true loop
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end loop;
end process;

-- Stimulus
process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';

    -- Normal operation
    wait for 200 ns;

    -- Emergency vehicle detected
    emergency <= '1';
    wait for 100 ns;

    emergency <= '0';
    wait for 200 ns;

    wait;
end process;

end Behavioral;
