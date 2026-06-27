library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddRoundKey is
    port(
        inState : in std_logic_vector(127 downto 0);
        inKey : in std_logic_vector(127 downto 0);
        outState : out std_logic_vector(127 downto 0)
    );
end entity AddRoundKey;

architecture arch of AddRoundKey is

begin
    outState <= inState xor inKey;
end arch;