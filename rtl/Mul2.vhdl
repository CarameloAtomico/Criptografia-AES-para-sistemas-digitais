library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mul2 is
    port(
        a : in std_logic_vector(7 downto 0);
        z : out std_logic_vector(7 downto 0)
    );
end entity Mul2;

architecture arch of Mul2 is
    signal shift1 : std_logic_vector(8 downto 0);
    signal shift2 : std_logic_vector(9 downto 0);
begin
    shift1 <= (a and "10000000") & '0';
    shift2 <= (shift1 xor "0000011011") & '0';

    z <= shift2(7 downto 0);
end architecture arch;