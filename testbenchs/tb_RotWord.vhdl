library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RotWord is
end entity tb_RotWord;

architecture behavioral of tb_RotWord is
    signal a : std_logic_vector(31 downto 0);
    signal z : std_logic_vector(31 downto 0);
begin

    ROTWORD_UUT: entity work.RotWord(arch)
        port map (
            a => a,
            z => z
        );

    dut_process : process
    begin
        a <= x"09cf4f3c";
        assert (z = x"cf4f3c09") report "Test failed for input 0x09cf4f3c" severity error;
        wait for 20 ns;
    end process;

end architecture behavioral;