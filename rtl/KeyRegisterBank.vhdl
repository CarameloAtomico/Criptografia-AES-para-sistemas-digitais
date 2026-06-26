library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity KeyRegisterBank is
    port (
        clk        : in std_logic;
        cRegisters   : in std_logic;
        index      : in unsigned(5 downto 0);
        key_in     : in std_logic_vector(127 downto 0);
        key_out    : out std_logic_vector(127 downto 0)
    );
end entity;

architecture arch of KeyRegisterBank is

    type key_array is array (0 to 10) of std_logic_vector(127 downto 0);
    signal mem : key_array;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if cRegisters = '1' then
                mem(to_integer(index)) <= key_in;
            end if;
        end if;
    end process;

    key_out <= mem(to_integer(index));

end architecture;