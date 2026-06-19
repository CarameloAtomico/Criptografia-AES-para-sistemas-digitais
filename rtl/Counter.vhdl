library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter is
    port (
        clk, enable, sel : in std_logic;
        maior : out std_logic
    );
end Counter;

architecture arch of Counter is
    signal i, mux_out, reg_out : std_logic_vector(3 downto 0);
begin
    mux : entity work.Mux2x1(arch)
        generic map (N => 4)
        port map (
            sel => sel, 
            in0 => i, 
            in1 => "0001", 
            z => mux_out
        );
    
    reg : entity work.VectorRegister(arch)
        generic map (N => 4)
        port map (clk => clk, 
            enable => enable, 
            inVector => mux_out, 
            outVector => reg_out
        );

    adder : entity work.HalfAdder_4bits(arch)
        port map (a => unsigned(reg_out), b => to_unsigned(1, 4), sum => unsigned(i));

    process(clk)
        variable sum : unsigned(i'range);
    begin
        if rising_edge(clk) then
            sum := sum+1;
        end if;
        i <= std_logic_vector(sum);
    end process;

    -- maior = 1 quando i for 9
    maior <= '1' when i = "1001" else '0';

end architecture arch;