library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub_byte_tb is
end entity sub_byte_tb;

architecture behavior of sub_byte_tb is

    component sub_byte
        port (
            pre_sbox : in std_logic_vector(127 downto 0);
            pos_sbox : out std_logic_vector(127 downto 0)
        );
    end component;

    signal t_pre_sbox : std_logic_vector(127 downto 0) := (others => '0');
    signal t_pos_sbox : std_logic_vector(127 downto 0);

begin

    uut: sub_byte
        port map (
            pre_sbox => t_pre_sbox,
            pos_sbox => t_pos_sbox
        );

    stim_proc: process
    begin		

        wait for 20 ns;

        t_pre_sbox <= x"00000000000000000000000000000000";
        wait for 40 ns;

        t_pre_sbox <= x"0F0E0D0C0B0A09080706050403020100";
        wait for 40 ns;

        t_pre_sbox <= x"193de3bea0f4e22b9ac68d2ae9f84808";
        wait for 40 ns;

        wait;
    end process;

end architecture behavior;