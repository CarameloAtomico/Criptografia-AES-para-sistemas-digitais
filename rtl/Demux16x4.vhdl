library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Demux16x4 is
    generic (
        N: positive := 8
    );
    port(
        sel : in std_logic_vector(3 downto 0);
        a : in std_logic_vector(N-1 downto 0);
        out00, out01, out02, out03, out04, out05, out06, out07,
        out08, out09, out10, out11, out12, out13, out14, out15 : out std_logic_vector(N-1 downto 0)
    );
end entity Demux16x4;

architecture arch of Demux16x4 is
begin
    process(sel, a)
    begin
        out00 <= (others => '0');
        out01 <= (others => '0');
        out02 <= (others => '0');
        out03 <= (others => '0');
        out04 <= (others => '0');
        out05 <= (others => '0');
        out06 <= (others => '0');
        out07 <= (others => '0');
        out08 <= (others => '0');
        out09 <= (others => '0');
        out10 <= (others => '0');
        out11 <= (others => '0');
        out12 <= (others => '0');
        out13 <= (others => '0');
        out14 <= (others => '0');
        out15 <= (others => '0');

        case(sel) is
            when "0000" =>
                out00 <= a;
            when "0001" =>
                out01 <= a;
            when "0010" =>
                out02 <= a;
            when "0011" =>
                out03 <= a;
            when "0100" =>
                out04 <= a;
            when "0101" =>
                out05 <= a;
            when "0110" =>
                out06 <= a;
            when "0111" =>
                out07 <= a;
            when "1000" =>
                out08 <= a;
            when "1001" =>
                out09 <= a;
            when "1010" =>
                out10 <= a;
            when "1011" =>
                out11 <= a;
            when "1100" =>
                out12 <= a;
            when "1101" =>
                out13 <= a;
            when "1110" =>
                out14 <= a;
            when "1111" =>
                out15 <= a;
            when others =>
                null; -- Do nothing for invalid sel values
        end case;
    end process;
end architecture arch;