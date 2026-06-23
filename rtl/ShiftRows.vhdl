library ieee;
use ieee.std_logic_1164.all;

entity ShiftRows is
    port (
        state_in : in std_logic_vector(127 downto 0);
        state_out : out std_logic_vector(127 downto 0)
    );
end entity ShiftRows;

architecture arch of ShiftRows is
    signal a, b, c, d : std_logic_vector(31 downto 0);
begin
    a <= state_in(127 downto 96);
    b <= state_in(87 downto 80) & state_in(79 downto 72) & state_in(71 downto 64) & state_in(95 downto 88);
    c <= state_in(47 downto 40) & state_in(39 downto 32) & state_in(63 downto 56) & state_in(55 downto 48);
    d <= state_in(7 downto 0) & state_in(31 downto 24) & state_in(23 downto 16) & state_in(15 downto 8);

    state_out <= a & b & c & d;
end architecture arch;