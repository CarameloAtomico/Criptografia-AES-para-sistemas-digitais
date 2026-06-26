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
    signal maior : std_logic;
    
    signal cState, cKey, cRoundCont, cFinalRound, cCipher : std_logic;
    
    signal sKey, sRoundCont, sSubBytes, sFinalRound : std_logic;
    signal cCont_sig : std_logic;
signal sMux_sig          : std_logic;
    
begin

    CB : entity work.FSM
        port map(
            clk         => clk,
            reset       => rst,
            start       => start,
            maior       => maior,
            cState      => cState,
            cKey        => cKey,
            cRoundCont  => cRoundCont,
            cFinalRound => cFinalRound,
            cCipher     => cCipher,
            sKey        => sKey,
            sRoundCont  => sRoundCont,
            sSubBytes   => sSubBytes,  
            sFinalRound => sFinalRound,
            doneSignal  => done        
        );
    
   OB : entity work.OB
        port map(
            clk         => clk,
            rst         => rst, 
            cState      => cState,
            cKey        => cKey,
            cRoundCont  => cRoundCont,
            cFinalRound => cFinalRound,
            cCipher     => cCipher,
            sKey        => sKey,
            sRoundCont  => sRoundCont,
            sFinalRound => sFinalRound,
            sMux        => sSubBytes,  
            plaintext   => plaintext,
            ent_key     => key,
            maior       => maior,
            ciphertext  => ciphertext
        );
end architecture arch;