library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    port (
        pre_sbox : in std_logic_vector(127 downto 0);
        enable : in std_logic;
        clk : in std_logic;
        pos_sbox : out std_logic_vector(127 downto 0)
    );
end entity SubBytes;

architecture arch of SubBytes is
    signal counter_output : std_logic_vector(3 downto 0);
    signal mux_output : std_logic_vector(7 downto 0);
    signal sbox_output : std_logic_vector(7 downto 0);

    signal enable_bytes : std_logic_vector(15 downto 0);

    signal out_bytes : std_logic_vector(15 downto 0)(7 downto 0);
    signal vector_out : std_logic_vector(127 downto 0);
begin

    counter : process(enable)
    begin
        for i in 0 to 15 loop
            if enable = '1' then
                counter_output <= std_logic_vector(to_unsigned(i, 4));
            else
                counter_output <= (others => '0');
            end if;
        end loop;
    end process;

    mux : entity work.Mux16x4
        port map(
            sel  => counter_output,
            in0  => pre_sbox(7 downto 0),
            in1  => pre_sbox(15 downto 8),
            in2  => pre_sbox(23 downto 16),
            in3  => pre_sbox(31 downto 24),
            in4  => pre_sbox(39 downto 32),
            in5  => pre_sbox(47 downto 40),
            in6  => pre_sbox(55 downto 48),
            in7  => pre_sbox(63 downto 56),
            in8  => pre_sbox(71 downto 64),
            in9  => pre_sbox(79 downto 72),
            in10 => pre_sbox(87 downto 80),
            in11 => pre_sbox(95 downto 88),
            in12 => pre_sbox(103 downto 96),
            in13 => pre_sbox(111 downto 104),
            in14 => pre_sbox(119 downto 112),
            in15 => pre_sbox(127 downto 120),
            z    => mux_output
        );

    sbox : entity work.ROM_Sbox
        port map(
            address  => mux_output,
            data_out => sbox_output
        );

    
    demux : entity work.Demux16x4
        generic map(
            N => 8
        )
        port map(
            sel   => counter_output,
            a     => sbox_output,
            out00 => std_logic_vector(out_bytes(0)),
            out01 => std_logic_vector(out_bytes(1)),
            out02 => std_logic_vector(out_bytes(2)),
            out03 => std_logic_vector(out_bytes(3)),
            out04 => std_logic_vector(out_bytes(4)),
            out05 => std_logic_vector(out_bytes(5)),
            out06 => std_logic_vector(out_bytes(6)),
            out07 => std_logic_vector(out_bytes(7)),
            out08 => std_logic_vector(out_bytes(8)),
            out09 => std_logic_vector(out_bytes(9)),
            out10 => std_logic_vector(out_bytes(10)),
            out11 => std_logic_vector(out_bytes(11)),
            out12 => std_logic_vector(out_bytes(12)),
            out13 => std_logic_vector(out_bytes(13)),
            out14 => std_logic_vector(out_bytes(14)),
            out15 => std_logic_vector(out_bytes(15))
        );

    gen_enable : for i in 0 to 15 generate
    begin
        enable_process : process(clk, counter_output, enable)
        begin
            enable_bytes(i) <= '1'
                when unsigned(counter_output) = i and enable = '1'
                else '0';
        end process;
    end generate gen_enable;

    gen_regs : for i in 0 to 15 generate
    begin
        reg_byte : entity work.VectorRegister
            generic map(
                N => 8
            )
            port map(
                clk        => clk,
                enable     => enable_bytes(i),
                vector_in  => std_logic_vector(out_bytes(i)),
                vector_out => vector_out(127 - i*8 downto 120 - i*8)
            );
    end generate gen_regs;


    final_reg : entity work.VectorRegister
        generic map(
            N => 128
        )
        port map(
            clk        => clk,
            enable     => enable_bytes(15), -- Enable the final register when the last byte is processed
            vector_in  => vector_out,
            vector_out => pos_sbox
        );
    

end architecture arch;