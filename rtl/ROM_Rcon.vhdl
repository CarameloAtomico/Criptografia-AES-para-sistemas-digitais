library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_Rcon is
    port (
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end entity ROM_Rcon;

architecture arch of ROM_Rcon is
    type rcon_array is array (0 to 9) of std_logic_vector(7 downto 0);

    constant RCON : rcon_array := (
     x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36"
    );
begin
    process(data_in)
        variable index : natural;
    begin
        index := to_integer(unsigned(data_in));
        if index >= 0 and index <= 9 then
            data_out <= RCON(index);
        else
            data_out <= (others => '0');
        end if;
    end process;
end architecture arch;