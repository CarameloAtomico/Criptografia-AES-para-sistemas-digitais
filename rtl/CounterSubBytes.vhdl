library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CounterSubBytes is
    port ( 
        clk, enable, sel : in std_logic;
        subBytesDone     : out std_logic;
        cLinhaColuna     : out std_logic_vector(3 downto 0)
    );
end CounterSubBytes;

architecture arch of CounterSubBytes is
    signal i                  : unsigned(3 downto 0); 
    signal muxOut, regOut   : std_logic_vector(3 downto 0);
begin

    mux: entity work.Mux2x1(arch)
        generic map (N => 4)
        port map (
            sel => sel, 
            in0 => std_logic_vector(i),
            in1 => "0000",
            z => muxOut
        );

    reg: entity work.VectorRegister(arch)
        generic map (N => 4)
        port map (
            clk        => clk, 
            enable     => enable, 
            vector_in  => muxOut, 
            vector_out => regOut
        );

    adder: entity work.HalfAdder(arch)
        generic map (N => 4)
        port map (
            a   => unsigned(regOut), 
            b   => "0001", 
            sum => i     
        );

    subBytesDone <= '1' when regOut = "1111" else '0';
    cLinhaColuna <= regOut;

end architecture arch;


