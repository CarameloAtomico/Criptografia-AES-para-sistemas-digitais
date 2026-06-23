library ieee;
use ieee.std_logic_1164.all;

entity G_Function is
    port (
        a : in std_logic_vector(31 downto 0);
        z : out std_logic_vector(31 downto 0)
    );
end entity G_Function;

architecture arch of G_Function is
    signal sboxOut, rconOut : std_logic_vector(31 downto 0);
begin
    gen_sboxes : for i in 0 to 3 generate
        sbox : entity work.ROM_Sbox
            port map(
                address  => a((i + 1) * 8 - 1  downto i * 8),
                data_out => sboxOut((i + 1) * 8 - 1 downto i * 8)
            );
    end generate gen_sboxes;
    
    gen_rcons : for i in 12 to 15 generate
        rcon : entity work.ROM_Rcon
            port map(
                data_in  => a((i + 1) * 8 - 1 downto i * 8),
                data_out => rconOut((i + 1) * 8 - 1 downto i * 8)
            );
    end generate gen_rcons;

    z <= rconOut xor sboxOut;
end architecture arch;
