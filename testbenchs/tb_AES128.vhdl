library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_AES128 is
end entity tb_AES128;

architecture behavioral of tb_AES128 is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal start : std_logic := '0';
    signal done : std_logic;
    signal key : std_logic_vector(127 downto 0) := x"2b7e151628aed2a6abf7158809cf4f3c";
    signal plaintext : std_logic_vector(127 downto 0) := x"3243f6a8885a308d313198a2e0370734";
    signal ciphertext : std_logic_vector(127 downto 0);

    constant CLK_PERIOD : time := 20 ns;
begin

    AES: entity work.AES128(arch)
        port map (
            clk => clk,
            rst => rst,
            start => start,
            plaintext => plaintext,
            key => key,
            ciphertext => ciphertext,
            done => done
        );

    clock_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    assert_process : process
    begin
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;
        start <= '1';
        wait for 20 ns;
        start <= '0';
        wait until done = '1';
        assert (ciphertext = x"3925841d02dc09fbdc118597196a0b32") report "Test failed for AES128" severity error;
        wait for 20 ns;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture behavioral;