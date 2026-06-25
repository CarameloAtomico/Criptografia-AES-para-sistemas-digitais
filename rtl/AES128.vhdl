library ieee;
use ieee.std_logic_1164.all;


entity AES128 is
    port (
        clk, rst, start : in std_logic;
        plaintext, key : in std_logic_vector(127 downto 0);
        ciphertext : out std_logic_vector(127 downto 0);
        done : out std_logic
    );
end entity AES128;

architecture arch of AES128 is
    signal maior : std_logic;
    signal cState, cKey, cAddKey, cRoundCont, cState_sbox, cState_shiftrows, cState_mixColumns, cFinalRound, cCipher, cCont, cLinhaColuna, cSubBytesCont : std_logic;
    signal sKey, sRoundCont, sMuxBox, sSubBytes, sFinalRound, sColMixed, sCont, sMux : std_logic;
begin
    CB : entity work.FSM
        port map(
            clk               => clk,
            reset             => rst,
            start             => start,
            maior             => maior,
            cState            => cState,
            cKey              => cKey,
            cAddKey           => cAddKey,
            cRoundCont        => cRoundCont,
            cState_sbox       => cState_sbox,
            cState_shiftrows  => cState_shiftrows,
            cState_mixColumns => cState_mixColumns,
            cFinalRound       => cFinalRound,
            cCipher           => cCipher,
            cCont             => cCont,
            cLinhaColuna      => cLinhaColuna,
            cSubBytesCont     => cSubBytesCont,
            sKey              => sKey,
            sRoundCont        => sRoundCont,
            sMuxBox           => sMuxBox,
            sSubBytes         => sSubBytes,
            sFinalRound       => sFinalRound,
            sCont             => sCont,
            sMux              => sMux,
            doneSignal        => done
        );
    
        OB : entity work.OB
            port map(
                clk               => clk,
                cState            => cState,
                cKey              => cKey,
                cAddKey           => cAddKey,
                cRoundCont        => cRoundCont,
                cState_sbox       => cState_sbox,
                cState_shiftrows  => cState_shiftrows,
                cState_mixColumns => cState_mixColumns,
                cFinalRound       => cFinalRound,
                cCipher           => cCipher,
                cCont             => cCont,
                cLinhaColuna      => cLinhaColuna,
                cSubBytesCont     => cSubBytesCont,
                sKey              => sKey,
                sRoundCont        => sRoundCont,
                sMuxSbox          => sMuxSbox,
                sSubBytes         => sSubBytes,
                sFinalRound       => sFinalRound,
                sCont             => sCont,
                sMux              => sMux,
                plaintext         => plaintext,
                ent_key           => key,
                maior             => maior,
                ciphertext        => ciphertext
            );
        
end architecture arch;