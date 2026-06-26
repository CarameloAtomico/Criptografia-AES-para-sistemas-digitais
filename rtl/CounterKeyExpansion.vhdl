library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CounterKeyExpasion is
    port (
        clk, sCont, cCont : in std_logic;
        indice : out std_logic_vector(5 downto 0);
        maior2 : out std_logic
    );
end entity;

architecture arch of CounterKeyExpasion is
    signal count : std_logic_vector(5 downto 0);
    signal compare : std_logic;
begin
    Mux2: entity work.Mux2x1
        generic map(
            N => 6
        )
        port map(
            sel => sCont,
            in0 => "000000",
            in1 => count,
            z   => indice
        );

    Comparator: entity work.Comparator
        generic map(
            N => 6
        )
        port map(
            a => unsigned(count),
            b => "100000",
            maior => compare
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if cCont = '1' then
                count <= std_logic_vector(unsigned(count) + 1);
                indice <= count;

                if (compare = '1') then
                    count <= "000000";
                    maior2 <= '1';
                    indice <= "000000";
                end if;
            end if;
        end if;
    end process;
end architecture arch;