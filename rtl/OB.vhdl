library ieee;
use ieee.std_logic_1164.all;

entity OB is
    port (
        -- Clock
        clk, rst : in std_logic; 
        -- Control
        cState, cKey, cRoundCont, cFinalRound, cCipher: in std_logic;
        sKey, sRoundCont,   sFinalRound, sMux : in std_logic;
        
        plaintext, ent_key : in std_logic_vector(127 downto 0);

        maior : out std_logic;
        -- Encrypted text        
        ciphertext : out std_logic_vector(127 downto 0)
    );
end entity OB;

architecture arch of OB is
   signal stateRegOut, keyRegOut       : std_logic_vector(127 downto 0);
    signal keyMuxOut, roundKey          : std_logic_vector(127 downto 0);
    signal addRndKey1Out, subBtsMuxOut  : std_logic_vector(127 downto 0);
    signal subBtsOut, sftRowOut         : std_logic_vector(127 downto 0);
    signal mixClmOut, finalRoundMuxOut  : std_logic_vector(127 downto 0);
    signal addRndKey2Out, finalRegOut   : std_logic_vector(127 downto 0);

    --for KeyExpansion
    signal roundCount : std_logic_vector(3 downto 0);
begin
    -- Count to 9
    counter : entity work.Counter
        generic map(
            limit => 9,
            N     => 4
        )
        port map(
        rst => rst,
            clk    => clk,
            enable => cRoundCont,
            sel    => sRoundCont,
            count => roundCount,
            maior  => maior
        );
    
    -- Encryption algorithm
    stateRegister : entity work.VectorRegister
    generic map( N => 128 )
    port map(
        clk        => clk,
        rst        => rst, 
        enable     => cState,
        vector_in  => plaintext,
        vector_out => stateRegOut
    );

keyRegister : entity work.VectorRegister
    generic map( N => 128 )
    port map(
        clk        => clk,
        rst        => rst, 
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
    
    addRoundKey_initial : entity work.AddRoundKey
        port map(
            inState  => stateRegOut,
            inKey    => keyMuxOut,
            outState => addRndKey1Out
        );
SubBytesMux : entity work.Mux2x1
        generic map(N => 128)
        port map(
            sel => sMux, -- Um sinal de seleção vindo da FSM (ex: '0' para texto inicial, '1' para rodadas)
            in0 => addRndKey1Out, -- Texto inicial + K0
            in1 => finalRegOut,   -- Resultado salvo da rodada anterior (Garante o sincronismo do clock!)
            z   => subBtsMuxOut
        );
    SubBytes : entity work.sub_byte
    port map(
        pre_sbox  => subBtsMuxOut,
        pos_sbox => subBtsOut
    );
    ShiftRows : entity work.ShiftRows
        port map(state_in => subBtsOut, state_out => SftRowOut);
    
    MixColumns_inst : entity work.MixColumns
        port map(
            inState  => SftRowOut,
            outState => mixClmOut
        );
    FinalRoundMux : entity work.Mux2x1
        generic map(N => 128)
        port map(sel => sFinalRound, in0 => mixClmOut, in1 => sftRowOut, z => finalRoundMuxOut);
    

    addRoundKey_rounds : entity work.AddRoundKey
        port map(
            inState  => finalRoundMuxOut,
            inKey    => roundKey,
            outState => addRndKey2Out
        );

    KeyExpansion_inst : entity work.KeyExpansion
        port map(
            key_in_1 => keyMuxOut(127 downto 96),
            key_in_2 => keyMuxOut(95 downto 64),
            key_in_3 => keyMuxOut(63 downto 32),
            key_in_4 => keyMuxOut(31 downto 0),
            round    => roundCount,
            key_out  => roundKey
        );

    -- Registrador de realimentação do laço interno do AES
    FinalRoundRegister : entity work.VectorRegister
        generic map(N => 128)
        port map(clk => clk,rst => rst,  enable => cFinalRound, vector_in => addRndKey2Out, vector_out => finalRegOut);

    -- 8. Registrador de Saída (Guarda o Ciphertext finalizado)
    CipherTextRegister : entity work.VectorRegister
        generic map(N => 128)
        port map(clk => clk, enable => cCipher,rst=> rst, vector_in => addRndKey2Out, vector_out => ciphertext);
        end architecture arch;