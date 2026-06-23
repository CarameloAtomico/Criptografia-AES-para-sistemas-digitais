library ieee;
use ieee.std_logic_1164.all;

entity RotWord is
    port (
        word_in : in std_logic_vector(31 downto 0);
        word_out : out std_logic_vector(31 downto 0)
    );
end entity RotWord;

architecture arch of RotWord is
    signal a, b, c, d : std_logic_vector(7 downto 0);
begin
    a <= word_in(31 downto 24);
    b <= word_in(23 downto 16);
    c <= word_in(15 downto 8);
    d <= word_in(7 downto 0);

    word_out <= b & c & d & a;
end architecture arch;