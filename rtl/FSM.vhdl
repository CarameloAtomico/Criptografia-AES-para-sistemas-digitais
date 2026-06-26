library ieee;
use ieee.std_logic_1164.all;

entity FSM is 
    port(
        clk, reset, start : in std_logic;
        maior, maior2     : in std_logic;

        cState, cKey,  cRoundCont, cFinalRound, sCont, cCont, cRegisters,
        sRoundCont, sFinalRound, sSubBytes, sAddFinal, cCipher : out std_logic;
        
        doneSignal                                     : out std_logic
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

    
    LPE : process(start, CurrentState, maior, maior2)
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
                if maior2 = '1' then
                    NextState <= INITIAL_ROUND;
                else
                    NextState <= KEY_EXPANSION;
                end if;
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
        
        cState      <= '0';
        cKey        <= '0';
        cRoundCont  <= '0';
        cFinalRound <= '0';
        cCipher     <= '0';
        sRoundCont  <= '0';
        sSubBytes   <= '0';
        sFinalRound <= '0';
        doneSignal  <= '0';
        cRoundCont <= '0'; 

        case CurrentState is
            when IDLE => 
               

            when LOAD => 
               
                cState <= '1'; 
                cKey   <= '1'; 

            when KEY_EXPANSION =>
                sCont <= '1';
                cCont <= '1';
                cRegisters <= '1';

            when INITIAL_ROUND =>
                
                sSubBytes   <= '1'; 
                sRoundCont  <= '1'; 
                cRoundCont  <= '1'; 

            when ROUND => 
               
                sSubBytes   <= '0'; 
                sFinalRound <= '1'; 
                cFinalRound <= '1'; 
                sRoundCont  <= '0'; 
                cRoundCont  <= '1'; 
                sAddFinal   <= '1';

            when FINAL_ROUND => 
                
                sSubBytes   <= '1'; 
                sFinalRound <= '1'; 
                sAddFinal   <= '0';

            when DONE => 
                
                cCipher    <= '1'; 
                doneSignal <= '1';

        end case;
    end process LS;

end architecture arch;