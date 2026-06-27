library ieee;
use ieee.std_logic_1164.all;

entity KeyExpansion is
    port (
        key_in_1 : in  std_logic_vector(31 downto 0); 
        key_in_2 : in  std_logic_vector(31 downto 0);
        key_in_3 : in  std_logic_vector(31 downto 0);
        key_in_4 : in  std_logic_vector(31 downto 0); 
        round    : in  std_logic_vector(3 downto 0);  
        key_out  : out std_logic_vector(127 downto 0)
    );
end entity;

architecture arch of KeyExpansion is

    signal GOut : std_logic_vector(31 downto 0);
    signal w0_new, w1_new, w2_new, w3_new : std_logic_vector(31 downto 0);
begin

    Gfunction : entity work.G_Function
        port map(
            a     => key_in_4,
            round => round,
            z     => GOut
        );
    
    w0_new <= key_in_1 xor GOut;
    w1_new <= w0_new   xor key_in_2;
    w2_new <= w1_new   xor key_in_3;
    w3_new <= w2_new   xor key_in_4;

    key_out <= w0_new & w1_new & w2_new & w3_new;
    
end architecture arch;
