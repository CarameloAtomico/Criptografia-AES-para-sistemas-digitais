library ieee;
use ieee.std_logic_1164.all;

entity tb_G_Function is
end entity tb_G_Function;

architecture behavior of tb_G_Function is

    component G_Function
        port (
            a       : in  std_logic_vector(31 downto 0);
            round   : in  std_logic_vector(3 downto 0);
            z       : out std_logic_vector(31 downto 0)
        );
    end component;

    signal t_a     : std_logic_vector(31 downto 0) := (others => '0');
    signal t_round : std_logic_vector(3 downto 0) := x"1";
    signal t_z     : std_logic_vector(31 downto 0);

begin

    uut: G_Function
        port map (
            a     => t_a,
            round => t_round,
            z     => t_z
        );

    stim_proc: process
    begin		
        wait for 20 ns;

        t_a     <= x"09cf4f3c";
        t_round <= x"1"; 
        wait for 40 ns;


        t_a     <= x"2a6c7605";
        t_round <= x"2";
        wait for 40 ns;

        wait;
    end process;

end architecture behavior;