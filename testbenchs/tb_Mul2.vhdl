library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Mul2 is
end entity tb_Mul2;

architecture behavioral of tb_Mul2 is
    signal a : std_logic_vector(7 downto 0);
    signal z : std_logic_vector(7 downto 0);
begin

    MUL2_UUT: entity work.Mul2(arch)
        port map (
            a => a,
            z => z
        );

    dut_process : process
    begin
        a <= x"57";
        assert (z = x"ae") report "Test failed for input 0x57" severity error;
        wait for 20 ns;

        a <= x"ae";
        assert (z = x"47") report "Test failed for input 0xae" severity error;
        wait for 20 ns;

        a <= x"47";
        assert (z = x"8e") report "Test failed for input 0x47" severity error;
        wait for 20 ns;

        a <= x"8e";
        assert (z = x"07") report "Test failed for input 0x8e" severity error;
        wait for 20 ns;
    end process;

end architecture behavioral;