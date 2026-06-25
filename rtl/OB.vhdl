library ieee;
use ieee.std_logic_1164.all;

entity OB is
    port (
        -- Clock
        clk : in std_logic;
        -- Control
        cState, cKey, cAddKey, cRoundCont, cState_sbox, cState_shiftrows, cState_mixColumns, cFinalRound, cCipher, cCont, cLinhaColuna, cSubBytesCont : in std_logic;
        sKey, sRoundCont, sMuxSbox, sSubBytes, sFinalRound, sCont, sMux : in std_logic;
        sColMixed : in std_logic_vector(1 downto 0);
        -- Text and key
        plaintext, ent_key : in std_logic_vector(127 downto 0);

        maior : out std_logic;
        -- Encrypted text        
        ciphertext : out std_logic_vector(127 downto 0)
    );
end entity OB;

architecture arch of OB is
    signal stateRegOut, keyRegOut, finalRoundRegOut : std_logic_vector(127 downto 0);
    signal keyMuxOut, subBtsMuxOut, finalRoundMuxOut, subBtsMuxInMuxOut : std_logic_vector(127 downto 0);
    signal sboxMuxOut : std_logic_vector(7 downto 0);
    signal subBtsOutSbx : std_logic_vector(7 downto 0);
    signal roundKey : std_logic_vector(127 downto 0);
    signal addRndKey1Out, addRndKey2Out, rconOut, subBtsOut, sftRowOut, mixClmOut : std_logic_vector(127 downto 0);
begin
    -- Count to 9
    counter : entity work.Counter
        generic map(
            limit => 9,
            N     => 4
        )
        port map(
            clk    => clk,
            enable => cRoundCont,
            sel    => sRoundCont,
            maior  => maior
        );
    
    -- Encryption algorithm
    stateRegister : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            enable     => cState,
            vector_in  => plaintext,
            vector_out => stateRegOut
        );

    keyRegister : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            enable     => cKey,
            vector_in  => ent_key,
            vector_out => keyRegOut
        );
    
    keyMux : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sKey,
            in0 => keyRegOut,
            in1 => roundKey,
            z   => keyMuxOut
        );
    
    -- Instanciar AddRoundKey aqui
    -- entrada1: stateRegOut
    -- entrada2: keyMuxOut
    -- saída: addRndKey1Out

    SubBytesMux : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sSubBytes,
            in0 => addRndKey2Out,
            in1 => subBtsMuxInMuxOut,
            z   => subBtsMuxOut
        );

    KeyExpansion : entity work.KeyExpansion
        port map(
            key_in_1 => keyMuxOut(127 downto 96),
            key_in_2 => keyMuxOut(95 downto 64),
            key_in_3 => keyMuxOut(63 downto 32),
            key_in_4 => keyMuxOut(31 downto 0)
            -- faltam seletores (acredito que tudo que falta são pronevientes de AddRoundKey)
            -- key_out  => 
            -- faltam outras saídas, preencher de acordo com o diagrama (e atualizar KeyExpansion.vhdl de acordo)
        );

    -- Bloco de registradores RoundKeys

    RCON : entity work.ROM_Rcon
        port map(
            -- Preencher a entrada com a saída de 32 bits de KeyExpansion, e a saída de acordo
            data_in  => data_in,
            data_out => data_out
        );

    sboxMux : entity work.Mux2x1
        generic map(
            N => 8
        )
        port map(
            sel => sMuxSbox,
            -- Saída de 8 bits do SubBytes
            in0 => in0,
            -- Saída de 8 bits do KeyExpansion
            in1 => in1,
            z   => subBtsOutSbx
        );

    Sbox : entity work.ROM_Sbox
        port map(
            -- Preencher de acordo, entrada <= sboxMuxOut, saída vai para KeyExpansion
            address  => address,
            data_out => data_out
        );
    
    
    ShiftRows : entity work.ShiftRows
        port map(
            state_in  => subBtsOut,
            state_out => SftRowOut
        );
    
    MixColumns : entity work.MixColumns
        port map(
            inState  => SftRowOut,
            sel      => sColMixed,
            clk      => clk,
            enable   => cState_mixColumns,
            outState => mixClmOut
        );

    FinalRoundMux : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sFinalRound,
            in0 => sftRowOut,
            in1 => mixClmOut,
            z   => finalRoundMuxOut
        );
    
    -- Instanciar AddRoundKey final aqui, de acordo com o diagrama, saída addRndKey2Out

    FinalRoundRegister : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            enable     => cFinalRound,
            vector_in  => addRndKey2Out,
            vector_out => finalRoundRegOut
        );

    -- Implementar Mux que decide se o sinal de FinalRoundRegister ou do AddRoundKey final vai para o Mux do SubBytes
    
    CipherTextRegister : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            enable     => cCipher,
            vector_in  => finalRoundMuxOut,
            vector_out => ciphertext
        );
    
    
end architecture arch;
