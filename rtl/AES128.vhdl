library ieee;
use ieee.std_logic_1164.all;

entity AES128 is
    port (
        clk, rst, start : in std_logic;
        plaintext, key   : in std_logic_vector(127 downto 0);
        ciphertext      : out std_logic_vector(127 downto 0);
        done            : out std_logic -- Porta de saída do topo
    );
end entity AES128;

architecture arch of AES128 is
    signal maior, maior2 : std_logic;
    
    signal cRegisters, cCont, cState, cKey, cRoundCont, cFinalRound, cCipher : std_logic;
    
    signal sAddFinal, sCont, sRoundCont, sSubBytes, sFinalRound : std_logic;
    signal doneSignal : std_logic;
    
begin

    CB : entity work.FSM
        port map(
            clk         => clk,
            reset       => rst,
            start       => start,
            maior       => maior,
            maior2      => maior2,
            cState      => cState,
            cKey        => cKey,
            cRoundCont  => cRoundCont,
            cFinalRound => cFinalRound,
            sCont       => sCont,
            cCont       => cCont,
            cRegisters  => cRegisters,
            sRoundCont  => sRoundCont,
            sFinalRound => sFinalRound,
            sSubBytes   => sSubBytes,
            sAddFinal   => sAddFinal,
            cCipher     => cCipher,
            doneSignal  => doneSignal
        );
        done <= doneSignal;

    OB : entity work.OB
        port map(
            clk         => clk,
            rst         => rst,
            cState      => cState,
            cKey        => cKey,
            cRoundCont  => cRoundCont,
            cFinalRound => cFinalRound,
            sCont       => sCont,
            cCont       => cCont,
            cRegisters  => cRegisters,
            sRoundCont  => sRoundCont,
            sFinalRound => sFinalRound,
            sSubBytes   => sSubBytes,
            sAddFinal   => sAddFinal,
            cCipher     => cCipher,
            plaintext   => plaintext,
            ent_key     => key,
            maior       => maior,
            maior2      => maior2,
            ciphertext  => ciphertext
        );
    
    
end architecture arch;