library ieee;
use ieee.std_logic_1164.all;

entity ShiftRows is
    port (
        inState : in std_logic_vector(127 downto 0);
        outState : out std_logic_vector(127 downto 0)
    );
end entity ShiftRows;

architecture arch of ShiftRows is
    signal a, b, c, d : std_logic_vector(31 downto 0);
begin
    a <= inState(127 downto 96);
    b <= inState(87 downto 80) & inState(79 downto 72) & inState(71 downto 64) & inState(95 downto 88);
    c <= inState(47 downto 40) & inState(39 downto 32) & inState(63 downto 56) & inState(55 downto 48);
    d <= inState(7 downto 0) & inState(31 downto 24) & inState(23 downto 16) & inState(15 downto 8);

    outState <= a & b & c & d;
end architecture arch;