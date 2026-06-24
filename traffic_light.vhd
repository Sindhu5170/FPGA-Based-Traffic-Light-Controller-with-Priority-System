library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light is
    Port (
        clk        : in STD_LOGIC;
        reset      : in STD_LOGIC;
        emergency  : in STD_LOGIC;
        north_red  : out STD_LOGIC;
        north_yel  : out STD_LOGIC;
        north_grn  : out STD_LOGIC;
        east_red   : out STD_LOGIC;
        east_yel   : out STD_LOGIC;
        east_grn   : out STD_LOGIC
    );
end traffic_light;

architecture Behavioral of traffic_light is

type state_type is (N_GREEN, N_YELLOW, E_GREEN, E_YELLOW, EMERGENCY);
signal state : state_type := N_GREEN;

signal counter : integer range 0 to 50_000_000 := 0;

begin

process(clk, reset)
begin
    if reset = '1' then
        state <= N_GREEN;
        counter <= 0;

    elsif rising_edge(clk) then

        -- Emergency override
        if emergency = '1' then
            state <= EMERGENCY;
        else

            case state is

                when N_GREEN =>
                    if counter = 20 then
                        state <= N_YELLOW;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;

                when N_YELLOW =>
                    if counter = 5 then
                        state <= E_GREEN;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;

                when E_GREEN =>
                    if counter = 20 then
                        state <= E_YELLOW;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;

                when E_YELLOW =>
                    if counter = 5 then
                        state <= N_GREEN;
                        counter <= 0;
                    else
                        counter <= counter + 1;
                    end if;

                when EMERGENCY =>
                    -- All red except north green (priority road)
                    state <= EMERGENCY;

            end case;

        end if;
    end if;
end process;

-- Output logic
process(state)
begin

    north_red <= '0';
    north_yel <= '0';
    north_grn <= '0';

    east_red  <= '0';
    east_yel  <= '0';
    east_grn  <= '0';

    case state is

        when N_GREEN =>
            north_grn <= '1';
            east_red  <= '1';

        when N_YELLOW =>
            north_yel <= '1';
            east_red  <= '1';

        when E_GREEN =>
            east_grn  <= '1';
            north_red <= '1';

        when E_YELLOW =>
            east_yel  <= '1';
            north_red <= '1';

        when EMERGENCY =>
            north_grn <= '1';
            east_red  <= '1';

    end case;

end process;

end Behavioral;
