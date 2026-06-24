library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is 
    port(
        clk, reset, start : in std_logic;
        maior : in std_logic;
        cState, cKey, cAddKey, cRoundCont, cState_sbox, cState_shiftrows, cState_mixColumns, cFinalRound, cCipher : out std_logic;
        sKey, sRoundCont, sMuxBox, sSubBytes, sFinalRound : out std_logic
    );
end entity FSM;

architecture arch of FSM is
    type state_type is (IDLE, LOAD, KEY_EXPANSION, INITIAL_ROUND, ROUND, FINAL_ROUND, DONE);
    signal CurrentState, NextState : state_type;
begin
    REG_STATE : process(clk, reset)
    begin
        if reset = '1' then
            CurrentState <= IDLE;
        elsif rising_edge(clk) then
            CurrentState <= NextState;
        end if;
    end process REG_STATE;

    LPE  : process(start, CurrentState, maior)
    begin
        case CurrentState is
            when IDLE =>
                if start = '1' then
                    NextState <= LOAD;
                else
                    NextState <= IDLE;
                end if;

            when LOAD =>
                NextState <= KEY_EXPANSION;

            when KEY_EXPANSION =>
                NextState <= INITIAL_ROUND;

            when INITIAL_ROUND =>
                NextState <= ROUND;

            when ROUND =>
                if maior = '1' then
                    NextState <= FINAL_ROUND;
                else
                    NextState <= ROUND;
                end if;

            when FINAL_ROUND =>
                NextState <= DONE;

            when DONE =>
                NextState <= IDLE;

        end case;
    end process LPE;

    LS : process(CurrentState)
    begin
        case CurrentState is
            when IDLE => 
            when LOAD => 
                cState <= '1';
                cKey <= '1';
            when KEY_EXPANSION =>
                cAddKey <= '1';
                sKey <= '1'; 
            when INITIAL_ROUND =>
                sRoundCont <= '1';
                cRoundCont <= '1';
                sMuxBox <= '1';
                cState <= '1'; 
            when ROUND => 
                cState_sbox <= '1';
                cState <= '1';
                sSubBytes <= '1';
                sMuxBox <= '0';
                cState_shiftrows <= '1';
                cState_mixColumns <= '1';
                sFinalRound <= '1';
                sRoundCont <= '0';
                cRoundCont <= '1';
            when FINAL_ROUND => 
                cState <= '1';
                cState_sbox <= '1';
                cState_shiftrows <= '1';
                cState_mixColumns <= '0';
                cAddKey <= '1';
                sFinalRound <= '0';
                cFinalRound <= '1';
                sSubBytes <= '0';
            when DONE => 
                cCipher <= '1';
        end case;
    end process LS;
end architecture arch;
