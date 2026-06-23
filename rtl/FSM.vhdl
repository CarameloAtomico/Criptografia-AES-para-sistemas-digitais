library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is 
    port(
        clk, reset, start : in std_logic;
        maior : in std_logic;
        cState, cKey, cAddKey, cRoundCont, cState_sbox, cSubBytes, cState_shiftrows, cState_mixColumns, cFinalRound : out std_logic;
        sKey, sRoundCont, sMuxBox, sState,  sFinalRound : out std_logic
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
    end process LS;
end architecture arch;
