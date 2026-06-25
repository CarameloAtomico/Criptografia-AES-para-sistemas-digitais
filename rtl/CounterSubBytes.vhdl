library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CounterSubBytes is
    port (
        clk          : in  std_logic;
        enable       : in  std_logic;
        sel          : in  std_logic;
        subBytesDone : out std_logic;
        cLinhaColuna : out std_logic_vector(3 downto 0)
    );
end entity CounterSubBytes;

architecture arch of CounterSubBytes is

    signal reg_out : std_logic_vector(3 downto 0);
    signal sum_out : unsigned(3 downto 0);
    signal mux_out : std_logic_vector(3 downto 0);

begin

    -- Soma 1 ao valor atual do contador
    adder: entity work.HalfAdder_4bits(arch)
        port map (
            a   => unsigned(reg_out),
            b   => to_unsigned(1, 4),
            sum => sum_out
        );

    -- Escolhe entre contar ou zerar
    mux: entity work.Mux2x1(arch)
        generic map (N => 4)
        port map (
            sel => sel,
            in0 => std_logic_vector(sum_out),
            in1 => (others => '0'),
            z => mux_out
        );

    -- Armazena o próximo valor
    reg: entity work.VectorRegister(arch)
        generic map (N => 4)
        port map (
            clk        => clk,
            enable     => enable,
            in_vector  => mux_out,
            out_vector => reg_out
        );

    subBytesDone <= '1' when reg_out = "1111" else '0';
    cLinhaColuna <= reg_out;

end architecture arch;