library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HalfAdder_4bits is
    port (
        a, b : in unsigned(3 downto 0);
        sum : out unsigned(3 downto 0)
    );
end entity HalfAdder_4bits;

architecture arch of HalfAdder_4bits is
begin
    sum <= a + b;
end architecture arch;