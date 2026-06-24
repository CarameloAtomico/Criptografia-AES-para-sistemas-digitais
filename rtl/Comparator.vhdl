library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Comparator is
    generic (
        N : positive := 4
        );
    port (
        a, b : in unsigned(N-1 downto 0);
        maior : out std_logic
    );
end entity Comparator;

architecture arch of Comparator is
begin
    maior <= '1' when a >= b else '0';
end architecture arch;