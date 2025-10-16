library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_tb is
end entity;

architecture struct of un_controle_tb is

    component un_controle is
     port( 
        instrucao : in unsigned(15 downto 0);
        acc0_ula : in unsigned(15 downto 0);
        acc1_ula : in unsigned(15 downto 0);
        banco_ula_UC : in unsigned(15 downto 0);
        acc_p_ula : out unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic;
        sel0_ULA : out std_logic;
        sel1_ULA : out std_logic;
        nop :out std_logic;
        qual_reg_op : out unsigned (3 downto 0)
        
   );
    end component;

    signal  JUMP_EN, CLK, finished: std_logic;
    signal INSTRU, acc0_ula_IN, acc1_ula_IN, banco_ula_IN, acc_p_ula_OUT: unsigned (15 downto 0) := (others => '0');
    signal ENDERECO: unsigned (6 downto 0):= (others => '0');
    signal sel0_ULA_out, sel1_ULA_out : std_logic:='0';
    signal qual_reg_op_OUT: unsigned (3 downto 0):= (others => '0');


begin
     uutUC: un_controle port map ( instrucao => INSTRU, acc0_ula => acc0_ula_IN, acc1_ula =>acc1_ula_IN, 
     banco_ula_UC => banco_ula_IN, acc_p_ula =>acc_p_ula_OUT, endereco_destino => ENDERECO, jump_en => JUMP_EN,
     sel0_ULA => sel0_ULA_out, sel1_ULA => sel1_ULA_out, qual_reg_op =>qual_reg_op_OUT );
     
     sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;
    clk_proc: process
            begin                       -- gera clock até que sim_time_proc termine
                while finished /= '1' loop
                CLK <= '0';
                wait for 50 ns;
                CLK <= '1';
                wait for 50 ns;
                end loop;
            wait;
    end process clk_proc;

    process
        begin
            wait for 200 ns;
            INSTRU <= "0010000000000100"; -- ADDI A, 4
            wait for 100 ns;
            INSTRU <= "0010100000010000";--ADDI B 16
            wait for 100 ns;
            INSTRU <= "0011000000000001"; --SUBI A, 1
            wait for 100 ns;
            INSTRU <= "0101110000000000"; --SUB B, REG8
            wait for 100 ns;
            INSTRU <= "0101110001111111"; --SUB B, REG8
            wait for 100 ns;
            INSTRU <= "0110100000000000"; -- AND B, REG0
            wait for 100 ns;
            INSTRU <= "0110001000000000"; -- AND A, REG4
            wait for 100 ns;
            INSTRU <= "1111111111111111"; -- é jump e endereco 1111111
            wait for 100 ns;
            INSTRU <= "1101111111111111";
            wait for 100 ns;
            INSTRU <= "0111111111111111";
            wait for 100 ns;
            INSTRU <= "1111111111000000"; -- é jump e endereco 1000000
            wait for 100 ns;
            INSTRU <= "1111011110000010"; -- é jump e endereco 0000010
            wait for 100 ns;
            INSTRU <= "1110111110000011"; -- NÃO é jump e endereco 0000011
            wait for 100 ns;
            wait;
    end process;
end architecture;

