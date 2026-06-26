library ieee;
use ieee.std_logic_1164.all;

entity tb_AES128 is

end entity tb_AES128;

architecture bench of tb_AES128 is
    
    constant CLK_PERIOD : time := 20 ns;

   signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal start      : std_logic := '0';
    signal plaintext  : std_logic_vector(127 downto 0) := (others => '0');
    signal key        : std_logic_vector(127 downto 0) := (others => '0');
   signal ciphertext : std_logic_vector(127 downto 0);
    signal done        : std_logic;
    signal sim_done    : boolean := false; 

begin

   
    UUT: entity work.AES128
        port map (
            clk        => clk,
            rst        => rst,
            start      => start,
            plaintext  => plaintext,
            key        => key,
            ciphertext => ciphertext,
            done       => done
        );

   
    clk_process : process
    begin
        while not sim_done loop 
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait; 
    end process;


    stim_proc: process
    begin
       
        rst <= '1';
        start <= '0';
        wait for CLK_PERIOD * 2;
        rst <= '0';
        wait for CLK_PERIOD;

      
        
        plaintext <= x"00112233445566778899aabbccddeeff";
        key       <= x"000102030405060708090a0b0c0d0e0f";
        
   
        wait for CLK_PERIOD;
        start <= '1';
        wait for CLK_PERIOD;
        start <= '0';

        
        wait for 2000 ns; 

       
        assert (ciphertext = x"69c4e0d86a7b0430d8cdb78070b4c55a")
            report "--- SUCESSO! O AES-128 CRIPTOGRAFOU CORRETAMENTE! ---"
            severity note;

        sim_done <= true; 
        wait;
    end process;

end architecture bench;