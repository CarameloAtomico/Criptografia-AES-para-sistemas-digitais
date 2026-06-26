library ieee;
use ieee.std_logic_1164.all;

entity tb_KeyExpansion is
end entity tb_KeyExpansion;

architecture behavior of tb_KeyExpansion is

    component KeyExpansion
        port (
            key_in_1 : in  std_logic_vector(31 downto 0);
            key_in_2 : in  std_logic_vector(31 downto 0);
            key_in_3 : in  std_logic_vector(31 downto 0);
            key_in_4 : in  std_logic_vector(31 downto 0);
            round    : in  std_logic_vector(3 downto 0);
            key_out  : out std_logic_vector(127 downto 0)
        );
    end component;

    signal t_k1    : std_logic_vector(31 downto 0) := (others => '0');
    signal t_k2    : std_logic_vector(31 downto 0) := (others => '0');
    signal t_k3    : std_logic_vector(31 downto 0) := (others => '0');
    signal t_k4    : std_logic_vector(31 downto 0) := (others => '0');
    signal t_round : std_logic_vector(3 downto 0)  := x"1"; -- Começa na Rodada 1
    signal t_key_out : std_logic_vector(127 downto 0);

begin

    uut: KeyExpansion
        port map (
            key_in_1 => t_k1,
            key_in_2 => t_k2,
            key_in_3 => t_k3,
            key_in_4 => t_k4,
            round    => t_round,
            key_out  => t_key_out
        );

    stim_proc: process
    begin		
        wait for 20 ns;

        t_k1    <= x"2b7e1516";
        t_k2    <= x"28aed2a6";
        t_k3    <= x"abf71588";
        t_k4    <= x"09cf4f3c";
        t_round <= x"1"; 
        
        wait for 40 ns;

        wait;
    end process;

end architecture behavior;