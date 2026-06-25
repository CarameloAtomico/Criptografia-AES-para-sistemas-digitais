library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_CounterSubBytes is
end entity tb_CounterSubBytes;

architecture sim of tb_CounterSubBytes is
    signal clk          : std_logic := '0';
    signal enable       : std_logic := '0';
    signal sel          : std_logic := '0';
    signal subBytesDone : std_logic;
    signal cLinhaColuna : std_logic_vector(3 downto 0);

    constant CLK_PERIOD : time := 20 ns;
    
    
    signal fim_simulacao : boolean := false;
begin

  
    UUT: entity work.CounterSubBytes(arch)
        port map (
            clk          => clk,
            enable       => enable,
            sel          => sel,
            subBytesDone => subBytesDone,
            cLinhaColuna => cLinhaColuna
        );

  
    clk_process : process
    begin
        while not fim_simulacao loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait; 
    end process;

  
    stim_process : process
    begin
       
        sel    <= '1'; 
        enable <= '1'; 
        wait for CLK_PERIOD;

       
        sel    <= '0'; 
        wait for CLK_PERIOD * 20; 

        
        enable <= '0';
        wait for CLK_PERIOD * 3;

       
        enable <= '1';
        sel    <= '1';
        wait for CLK_PERIOD * 2;
        
      
        fim_simulacao <= true;
        wait; 
    end process;
end architecture sim;
