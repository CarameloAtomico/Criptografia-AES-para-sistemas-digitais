library ieee;
use ieee.std_logic_1164.all;

entity KeyExpansion is
    port (
        key_in_1, key_in_2, key_in_3, key_in_4 : in std_logic_vector(31 downto 0);
        key_out : out std_logic_vector(127 downto 0)
    );
end entity;

architecture arch of KeyExpansion is

    signal GOut : std_logic_vector(31 downto 0);
    signal w0, w1, w2, w3 : std_logic_vector(31 downto 0);

begin

    Gfunction : entity work.G_Function
        port map(
            a     => key_in_4,
            round => "0001", -- se você já fixou isso internamente
            z     => GOut
        );


    w0 <= key_in_1 xor GOut;
    w1 <= key_in_2 xor w0;
    w2 <= key_in_3 xor w1;
    w3 <= key_in_4 xor w2;

    key_out <= w0 & w1 & w2 & w3;

end architecture;