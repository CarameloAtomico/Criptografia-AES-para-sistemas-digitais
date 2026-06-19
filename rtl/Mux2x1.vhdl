library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux2x1 is
    generic(
        N : positive
    );
    port(
        sel : in std_logic;
        in0, in1 : in std_logic_vector(N-1 downto 0);
        z : out std_logic_vector(N-1 downto 0)
    );
end entity Mux2x1;

architecture arch of Mux2x1 is
begin
    z <= in0 when sel = '0' else
         in1;
end architecture arch;