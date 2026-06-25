library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddRoundKey is
    port(
        clk : in std_logic;
        inState : in std_logic_vector(127 downto 0);
        inKey : in std_logic_vector(127 downto 0);
        outState : out std_logic_vector(127 downto 0)
    );
end entity AddRoundKey;

architecture arch of AddRoundKey is
    signal sel : std_logic_vector(3 downto 0);
    signal key_i, state_i : std_logic_vector(7 downto 0);
    signal stateReg : std_logic_vector(127 downto 0);
    signal stateByte : std_logic_vector(7 downto 0);
begin

    mux16key : entity work.Mux16x4
        port map(
            in0 => inKey(127 downto 120),
            in1 => inKey(119 downto 112),
            in2 => inKey(111 downto 104),
            in3 => inKey(103 downto 96),
            in4 => inKey(95 downto 88),
            in5 => inKey(87 downto 80),
            in6 => inKey(79 downto 72),
            in7 => inKey(71 downto 64),
            in8 => inKey(63 downto 56),
            in9 => inKey(55 downto 48),
            in10 => inKey(47 downto 40),
            in11 => inKey(39 downto 32),
            in12 => inKey(31 downto 24),
            in13 => inKey(23 downto 16),
            in14 => inKey(15 downto 8),
            in15 => inKey(7 downto 0),
            sel => sel,
            z => key_i
        );

    mux16state : entity work.Mux16x4
        port map(
            in0 => inState(127 downto 120),
            in1 => inState(119 downto 112),
            in2 => inState(111 downto 104),
            in3 => inState(103 downto 96),
            in4 => inState(95 downto 88),
            in5 => inState(87 downto 80),
            in6 => inState(79 downto 72),
            in7 => inState(71 downto 64),
            in8 => inState(63 downto 56),
            in9 => inState(55 downto 48),
            in10 => inState(47 downto 40),
            in11 => inState(39 downto 32),
            in12 => inState(31 downto 24),
            in13 => inState(23 downto 16),
            in14 => inState(15 downto 8),
            in15 => inState(7 downto 0),
            sel => sel,
            z => state_i
        );


    ADDFOR: process(clk)
    
    begin
        for j in 0 to 15 loop
            sel <= std_logic_vector(to_unsigned(j, 4));
            stateByte <= state_i XOR key_i;
            stateReg((127-(8*j)) downto (120-(8*j))) <= stateByte;
            

        end loop;

    end process ADDFOR;

    outState <= stateReg;


end arch;