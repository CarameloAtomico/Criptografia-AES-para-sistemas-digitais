library ieee;
use ieee.std_logic_1164.all;

entity KeyExpansion is
    port (
        key_in_1, key_in_2, key_in_3, key_in_4 : in std_logic_vector(31 downto 0);
        key_out : out std_logic_vector(127 downto 0)
    );
end entity KeyExpansion;

architecture arch of KeyExpansion is
    signal GOut : std_logic_vector(31 downto 0);
    signal xor1, xor2, xor3 : std_logic_vector(31 downto 0);
begin
    Gfunction : entity work.G_Function
        port map(
            a => key_in_1,
            z => GOut
        );
    
    xor1 <= key_in_1 xor Gout;
    xor2 <= xor1 xor key_in_2;
    xor3 <= xor2 xor key_in_3;

    key_out <= xor1 & xor2 & xor3 & (xor3 xor key_in_4);
    
    end architecture arch;