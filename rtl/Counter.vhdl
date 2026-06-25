library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter is
    generic (
        limit : positive := 9;
        N : positive := 4
        );
    port (
        clk, enable, sel : in std_logic;
        maior : out std_logic
    );
end Counter;

architecture arch of Counter is
    signal i : unsigned(N - 1 downto 0); 
    signal muxOut, regOut : std_logic_vector(N - 1 downto 0);
begin
    mux : entity work.Mux2x1(arch)
        generic map (N => N)
        port map (
            sel => sel, 
            in0 => std_logic_vector(i), 
            in1 => std_logic_vector(to_unsigned(1, N)), 
            z => muxOut
        );
    
    reg : entity work.VectorRegister(arch)
        generic map (N => N)
        port map (clk => clk, 
            enable => enable, 
            vector_in => muxOut, 
            vector_out => regOut
        );

    adder : entity work.HalfAdder(arch)
        generic map (N => N)
        port map (
            a => unsigned(regOut), 
            b => to_unsigned(1, N), 
            sum => i
        );

    comparator : entity work.Comparator
        generic map(
            N => N
        )
        port map(
            a     => i,
            b     => to_unsigned(limit, N),
            maior => maior
        );
end architecture arch;