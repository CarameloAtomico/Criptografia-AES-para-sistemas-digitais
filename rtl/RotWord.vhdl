library ieee;
use ieee.std_logic_1164.all;

entity RotWord is
    inWord : in std_logic_vector(31 downto 0);
    outWord : out std_logic_vector(31 downto 0)
end RotWord;

architecture arch of RotWord is
    signal a, b, c, d : std_logic_vector(7 downto 0);
begin
    a <= inWord(31 downto 24);
    b <= inWord(23 downto 16);
    c <= inWord(15 downto 8);
    d <= inWord(7 downto 0);

    outWord <= b & c & d & a;
end architecture arch;