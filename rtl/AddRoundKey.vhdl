library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AddRoundKey is
    port(
        clk : in std_logic;
        inState : in std_logic_vector(127 downto 0);
        inKey : in std_logic_vector(127 downto 0);
        outState : out std_logic_vector(127 downto 0);
        outIndex : out std_logic_vector(5 downto 0)
    );
end entity AddRoundKey;

architecture arch of AddRoundKey is
    signal j : std_logic_vector(3 downto 0);
    signal key_i, state_i, nstate : std_logic_vector(7 downto 0);
    signal enableDeSinalNaoNulo : std_logic;
    signal menor : std_logic; -- Conter : sel e maior
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
            sel => j,
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
            sel => j,
            z => state_i
        );

    nstate <= state_i XOR key_i;
    enableDeSinalNaoNulo <= nstate(0) or nstate(1) or nstate(2) or nstate(3) or nstate(4) or nstate(5) or nstate(6) or nstate(7)

    regstate : entity work.VectorRegister
        generic map(
            N => 128 -- Isso para o valor final
        )
        port map(
            clk        => clk,
            enable     => enableDeSinalNaoNulo,
            vector_in  => nstate,
            vector_out => outState --Inadequado
            -- Gostaria que esse registrador fosse concatenando os valores que recebe até chegar em 128 bits
        );

    menor <= std_logic(0);
    Countj : entity work.Counter
        generic map(
            limit => 15,
            N     => 4
        )
        port map(
            clk    => clk,
            enable => enableDeSinalNaoNulo,
            sel    => menor,
            maior  => not(menor)
        );

    ContIndex : entity work.Counter
        generic map(
            limit => 44,
            N     => 6
        )
        port map(
            clk    => clk,
            enable => enable,
            sel    => sel,
            maior  => maior
        );
    
    
    
    


end arch;