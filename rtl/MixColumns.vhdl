library ieee;
use ieee.std_logic_1164.all;

entity MixColumns is
    port (
        inState : in std_logic_vector(127 downto 0);
        outState : out std_logic_vector(127 downto 0)
    );
end entity MixColumns;

architecture arch of MixColumns is
    type byte_array is array (0 to 15) of std_logic_vector(7 downto 0);
    signal state : byte_array;
    signal mul2 : byte_array;
    signal result : byte_array;
begin
    gen_bytes : for i in 0 to 15 generate
    begin
        state(i) <= inState(127-8*i downto 120-8*i);
    end generate;

    gen_mul2 : for i in 0 to 15 generate
    begin
        genMUL2 : entity work.Mul2
            port map(
                a => state(i),
                z => mul2(i)
            );
    end generate;

    gen_columns : for c in 0 to 3 generate
    begin

        result(c) <=
            mul2(c)
            xor (mul2(c+4) xor state(c+4))
            xor state(c+8)
            xor state(c+12);

        result(c+4) <=
            state(c)
            xor mul2(c+4)
            xor (mul2(c+8) xor state(c+8))
            xor state(c+12);

        result(c+8) <=
            state(c)
            xor state(c+4)
            xor mul2(c+8)
            xor (mul2(c+12) xor state(c+12));

        result(c+12) <=
            (mul2(c) xor state(c))
            xor state(c+4)
            xor state(c+8)
            xor mul2(c+12);

    end generate;

    gen_output : for i in 0 to 15 generate
    begin
        outState(127-8*i downto 120-8*i) <= result(i);
    end generate;
                
end architecture arch;