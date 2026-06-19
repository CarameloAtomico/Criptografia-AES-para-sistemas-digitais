library ieee;
use ieee.std_logic_1164.all;


entity AES128 is
    port (
        clk, rst, start : in std_logic;
        plaintext, key : in std_logic_vector(127 downto 0);
        ciphertext : out std_logic_vector(127 downto 0);
        done : out std_logic
    );
end entity AES128;

architecture arch of AES128 is
begin

end architecture arch;