library ieee;
use ieee.std_logic_1164.all;

entity Mul2 is
    port(
        a : in  std_logic_vector(7 downto 0);
        z : out std_logic_vector(7 downto 0)
    );
end entity;

architecture arch of Mul2 is
    signal shifted : std_logic_vector(7 downto 0);
begin
    shifted <= a(6 downto 0) & '0';

    z <= shifted
         when a(7) = '0'
         else shifted xor x"1B";
end architecture;