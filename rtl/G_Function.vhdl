library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity G_Function is
    port (
        a       : in  std_logic_vector(31 downto 0);
        round   : in  std_logic_vector(3 downto 0); 
        z       : out std_logic_vector(31 downto 0)
    );
end entity G_Function;

architecture arch of G_Function is
    signal rotated : std_logic_vector(31 downto 0);
    signal sboxOut : std_logic_vector(31 downto 0);
    signal rconByte : std_logic_vector(7 downto 0);
    
    signal rcon_address_8bit : std_logic_vector(7 downto 0);
    signal round_minus_one    : unsigned(3 downto 0);
begin

    rotword : entity work.RotWord
        port map(
            word_in  => a,
            word_out => rotated
        );    

	sbox3 : entity work.ROM_Sbox port map(address => rotated(31 downto 24), data_out => sboxOut(31 downto 24));
	sbox2 : entity work.ROM_Sbox port map(address => rotated(23 downto 16), data_out => sboxOut(23 downto 16));
	sbox1 : entity work.ROM_Sbox port map(address => rotated(15 downto 8),  data_out => sboxOut(15 downto 8));
	sbox0 : entity work.ROM_Sbox port map(address => rotated(7 downto 0),   data_out => sboxOut(7 downto 0));
    
    round_minus_one <= unsigned(round) - 1;

    rcon_address_8bit <= "0000" & std_logic_vector(round_minus_one);

    rcon_inst : entity work.ROM_Rcon
        port map(
            data_in  => rcon_address_8bit,
            data_out => rconByte
        );

    z(31 downto 24) <= sboxOut(31 downto 24) xor rconByte;
    z(23 downto 0)  <= sboxOut(23 downto 0); 

end architecture arch;