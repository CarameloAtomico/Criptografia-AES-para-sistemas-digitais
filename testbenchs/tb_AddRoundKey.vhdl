library ieee;
use ieee.std_logic_1164.all;

entity tb_AddRoundKey is
end entity tb_AddRoundKey;

architecture behavior of tb_AddRoundKey is

    component AddRoundKey
        port(
            inState  : in  std_logic_vector(127 downto 0);
            inKey    : in  std_logic_vector(127 downto 0);
            outState : out std_logic_vector(127 downto 0)
        );
    end component;

    signal t_inState  : std_logic_vector(127 downto 0) := (others => '0');
    signal t_inKey    : std_logic_vector(127 downto 0) := (others => '0');
    signal t_outState : std_logic_vector(127 downto 0);

begin

    uut: AddRoundKey
        port map (
            inState  => t_inState,
            inKey    => t_inKey,
            outState => t_outState
        );

    stim_proc: process
    begin		
        wait for 20 ns;

        t_inState <= x"A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5";
        t_inKey   <= x"A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5";
        wait for 40 ns; 


        t_inState <= x"193de3bea0f4e22b9ac68d2ae9f84808";
        t_inKey   <= x"a0fafe1788542cb123a339392a6c7605";
        wait for 40 ns; 

        t_inState <= x"0123456789ABCDEF0123456789ABCDEF";
        t_inKey   <= x"00000000000000000000000000000000";
        wait for 40 ns; 
        
        wait;
    end process;

end architecture behavior;