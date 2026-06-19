library ieee;
use ieee.std_logic_1164.all;

entity Mux4x2_8bits is
    port(
        sel : in std_logic_vector(1 downto 0);
        in00, in01, in10, in11 : in std_logic_vector(7 downto 0);
        z : out std_logic_vector(7 downto 0)
    );
end entity Mux4x2_8bits;

architecture arch of Mux4x2_8bits is
begin
    z <= in00 when sel = "00" else
         in01 when sel = "01" else
         in10 when sel = "10" else
         in11;
end architecture arch;