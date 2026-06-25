library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub_byte is
	port (
		pre_sbox : in std_logic_vector(127 downto 0);
		pos_sbox : out std_logic_vector(127 downto 0)
	);
end sub_byte;

architecture behavioral of sub_byte is
	
begin
	gen : for i in 0 to 15 generate
		sbox_inst : entity work.ROM_Sbox
			port map(
				address  => pre_sbox((i + 1)*8 - 1 downto i*8),
				data_out => pos_sbox((i + 1)*8 - 1 downto i*8)
			);		
	end generate gen;
	
end architecture behavioral;
