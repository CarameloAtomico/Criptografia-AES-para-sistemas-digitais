library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HalfAdder is
    generic (
        N : positive := 4
        );
    port (
        a, b : in unsigned(N - 1 downto 0);
        sum : out unsigned(N - 1 downto 0)
    );
end entity HalfAdder;

architecture arch of HalfAdder is
begin
    sum <= a + b;
end architecture arch;