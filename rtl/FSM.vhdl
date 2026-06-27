library ieee;
use ieee.std_logic_1164.all;

entity FSM is 
    port(
        clk, reset, start : in std_logic;
        maior             : in std_logic;
        
        cState, cKey, cRoundCont, cFinalRound, cCipher : out std_logic;
       
        sKey, sRoundCont, sSubBytes, sFinalRound       : out std_logic;
        
        doneSignal                                     : out std_logic
    );
end entity FSM;

architecture arch of FSM is
    
    type state_type is (IDLE, LOAD, INITIAL_ROUND, ROUND, FINAL_ROUND, DONE);
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

    
    LPE : process(start, CurrentState, maior)
    begin
        case CurrentState is
            when IDLE =>
                if start = '1' then
                    NextState <= LOAD;
                else
                    NextState <= IDLE;
                end if;

            when LOAD =>
                
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

            when others =>
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
        sKey        <= '0';
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

            when INITIAL_ROUND =>
                
                sKey        <= '0';
                sSubBytes   <= '0'; 
                cFinalRound <= '1'; 
                
                
                sRoundCont  <= '1'; 
                cRoundCont  <= '1'; 
            when ROUND => 
               
                sSubBytes   <= '1'; 
                sKey        <= '1';
                sFinalRound <= '0'; 
                cFinalRound <= '1'; 
                
                
                sRoundCont  <= '0'; 
                cRoundCont  <= '1'; 

            when FINAL_ROUND => 
                
                sSubBytes   <= '1'; 
                sKey        <= '1'; 
                sFinalRound <= '1'; 
                
              
            when DONE => 
                
                cCipher    <= '1'; 
                doneSignal <= '1';

        end case;
    end process LS;

end architecture arch;