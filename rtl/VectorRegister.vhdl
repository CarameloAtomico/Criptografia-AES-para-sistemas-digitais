library ieee;
use ieee.std_logic_1164.all;

entity VectorRegister is
    generic(
        N: positive
    );
    port (
        clk, enable: in std_logic;
        inVector: in std_logic_vector(N-1 downto 0);
        outVector: out std_logic_vector(N-1 downto 0)
    );
end entity VectorRegister;

architecture arch of VectorRegister is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (enable = '1') then
                outVector <= inVector;
            end if;
        end if;
    end process;
end architecture arch;