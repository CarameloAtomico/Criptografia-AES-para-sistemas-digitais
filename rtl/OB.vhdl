library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity OB is
    port (
        -- Clock
        clk, rst : in std_logic; 
        -- Control
        cState, cKey,  cRoundCont, cFinalRound, sCont, cCont, cRegisters,
        sRoundCont, sFinalRound, sSubBytes, sAddFinal, cCipher : in std_logic;
        
        plaintext, ent_key : in std_logic_vector(127 downto 0);

        maior, maior2 : out std_logic;
        -- Encrypted text        
        ciphertext : out std_logic_vector(127 downto 0)
    );
end entity OB;

architecture arch of OB is
    signal stateRegister, keyRegister : std_logic_vector(127 downto 0);
    signal firstAddRoundOut, keyExpansion_out : std_logic_vector(127 downto 0);
    signal keyExpansion_round : std_logic_vector(3 downto 0);
    signal indeces : std_logic_vector(5 downto 0); 

    -- Mux antes do SubBytes
    signal muxFinalRoundOut, muxFinalRound, muxOut : std_logic_vector(127 downto 0);

    signal BankRegisterOut, SubBytesOut, ShiftRowsOut, MixColumnsOut, MuxRoundFinal : std_logic_vector(127 downto 0);
    signal final_round_register_out : std_logic_vector(127 downto 0);
begin


    -- Contador de Rounds
    counter : entity work.Counter
        generic map(
            limit => 9,
            N     => 4
        )
        port map(
            clk    => clk,
            rst    => rst,
            enable => cRoundCont,
            sel    => sRoundCont,
            count  => keyExpansion_round,
            maior  => maior
        );
    

    state : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            rst        => rst,
            enable     => cState,
            vector_in  => plaintext,
            vector_out => stateRegister
        );

    key : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            rst        => rst,
            enable     => cKey,
            vector_in  => ent_key,
            vector_out => keyRegister
        );

    keyExoand : entity work.KeyExpansion
        port map(
            key_in_1 => keyRegister(127 downto 96),
            key_in_2 => keyRegister(95 downto 64),
            key_in_3 => keyRegister(63 downto 32),
            key_in_4 => keyRegister(31 downto 0),
            round    => keyExpansion_round,
            key_out  => keyExpansion_out,
            sCont    => sCont,
            cCont    => cCont,
            indeces  => indeces,
            maior2   => maior2,
            clk => clk
        );

    BlocoRegistradores : entity work.KeyRegisterBank
        port map(
            clk        => clk,
            cRegisters => cRegisters,
            index      => unsigned(indeces),
            key_in     => keyExpansion_out,
            key_out    => BankRegisterOut
        );
    
    

    firstAddRoundKey : entity work.AddRoundKey
        port map(
            inState  => stateRegister,
            inKey    => keyRegister,
            outState => firstAddRoundOut
        );

    -- Início dos rounds de criptografia
    muxRound : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sSubBytes,
            in0 => muxFinalRound,
            in1 => firstAddRoundOut,
            z   => muxOut
        );

    subBytes : entity work.sub_byte
        port map(
            pre_sbox => muxOut,
            pos_sbox => SubBytesOut
        );

    ShiftRows : entity work.ShiftRows
        port map(
            state_in  => SubBytesOut,
            state_out => ShiftRowsOut
        );

    mixColumns : entity work.MixColumns
        port map(
            inState  => ShiftRowsOut,
            outState => MixColumnsOut
        );
    


    muxColumns : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sFinalRound,
            in0 => ShiftRowsOut,
            in1 => MixColumnsOut,
            z   => MuxRoundFinal
        );

    FinalAddRoundKey : entity work.AddRoundKey
        port map(
            inState  => MuxRoundFinal,
            inKey    => BankRegisterOut,
            outState => muxFinalRoundOut
        );

    final_round_register : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            rst        => rst,
            enable     => cFinalround,
            vector_in  => muxFinalRoundOut,
            vector_out => final_round_register_out
        );
    

    muxFinalRoundKey : entity work.Mux2x1
        generic map(
            N => 128
        )
        port map(
            sel => sAddFinal,
            in0 => final_round_register_out,
            in1 => muxFinalRoundOut,
            z   => muxFinalRound
        );
        

    ciphertext_register : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            rst        => rst,
            enable     => cCipher,
            vector_in  => final_round_register_out,
            vector_out => ciphertext
        );
    
    

end architecture arch;