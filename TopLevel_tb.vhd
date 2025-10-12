library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel_tb is
end entity;

architecture struct of TopLevel_tb is

    component TopLevel is
    port (
        clock : in std_logic;
        --elementos do banco
        dado_ext_escrita_banco : in unsigned(15 downto 0);
        reset_b, escreve_banco : in std_logic; --escreve banco é o write enable do banco
        qual_reg_escreve, qual_reg_le : in unsigned(3 downto 0); 

        --elementos dos accs
        reset_acc, escreve_acc, escolhe_accA, escolhe_accB : in std_logic; --o reset é dos dois e o escreve_accs e os escolhe em conjunto são o wr_en deles
        dado_ext_escrita_acc : in unsigned(15 downto 0);

        --operação com cte (ADDI/SUBI), operação MOV Rn, ACC vai pro registrador, operação MOV ACC, Rn vai pro acumulador, operação de LD nos acumuladores
        op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc : in std_logic;  
        cte : in unsigned(15 downto 0); --a cte que vem da instrução

        --elemento da ULA
        sel0, sel1 : in std_logic; --operações da ula
        carry, overflow, zero, sinal : out std_logic;

        --elementos da UC
        reset_uc, wr_uc : in std_logic
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_accA, escolhe_accB, escreve_acc, sel0, sel1, carry, overflow, zero, sinal, finished, op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc  : std_logic;
    signal dado_ext_escrita_banco, dado_ext_escrita_acc, cte, saida_rom : unsigned(15 downto 0);
    signal qual_reg_escreve, qual_reg_le : unsigned(3 downto 0);
    -----
    signal reset_uc, wr_uc : std_logic;

begin
    uut : TopLevel port map (clock => clock, dado_ext_escrita_banco => dado_ext_escrita_banco, reset_b => reset_b, reset_acc => reset_acc, 
    qual_reg_escreve => qual_reg_escreve, qual_reg_le => qual_reg_le, escreve_banco => escreve_banco, escolhe_accA => escolhe_accA, 
    escolhe_accB => escolhe_accB, escreve_acc => escreve_acc, dado_ext_escrita_acc => dado_ext_escrita_acc, op_com_cte => op_com_cte, 
    cte => cte, sel0 => sel0, sel1 => sel1, carry => carry, overflow => overflow, zero => zero, sinal => sinal, 
    op_mov_p_reg => op_mov_p_reg, op_mov_p_acc => op_mov_p_acc, op_ld_acc => op_ld_acc, reset_uc => reset_uc, wr_uc => wr_uc);

    reset_global: process
    begin
        reset_b <= '1';
        reset_acc <= '1';
        reset_uc <= '1';
        wait for 100 ns; 
        reset_b <= '0';
        reset_acc <= '0';
        reset_uc <= '0';
        wr_uc <= '1';
        wait for 100 ns;
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clock <= '0';
            wait for 50 ns;
            clock <= '1';
            wait for 50 ns;
        end loop;
        wait;
    end process clk_proc;

    --o que importa é o data_out dos acumuladores, porque isso que diz se o valor da instrução foi guardado neles

    process                      -- sinais dos casos de teste (p.ex.)
    begin
      wait for 200 ns;
      --seta as coisas em zero pra não ficar indefinido
      escolhe_accA <= '0';
      escolhe_accB <= '0'; 
      op_com_cte <= '0';
      op_mov_p_reg <= '0';
      op_mov_p_acc <= '0';
      op_ld_acc <= '0';
      escreve_banco <= '0';

      --ADD A, R3!!!!
      --(op parcial LD R3, 7)
      escreve_banco <= '1'; 
      qual_reg_escreve <= "0011"; 
      dado_ext_escrita_banco <= "0000000000000111"; 

      wait for 100 ns;
      --(op parcial leio o r3)
      sel0 <= '0'; --só pra dizer que fica fazendo soma
      sel1 <= '0';  
      escolhe_accA <= '1'; --escolho o accA pra somar com o r3 
      escreve_acc <= '1';
      qual_reg_le <= "0011";   
      escreve_banco <= '0';
      
      wait for 100 ns;
      escolhe_accA <= '0'; --desabilito ele porque já usei
      escreve_acc <= '0';

      wait for 100 ns;
      --ADD A, R6!!!
      --(op parcial LD r6, 5)
      escreve_banco <= '1'; 
      qual_reg_escreve <= "0110"; 
      dado_ext_escrita_banco <= "0000000000000101"; 

      wait for 100 ns;
      --(op parcial leio o r6)
      qual_reg_le <= "0110"; 
      escolhe_accA <= '1'; --escolho o accA  
      escreve_acc <= '1';  
      escreve_banco <= '0';


      wait for 100 ns;
      escolhe_accA <= '0';
      escreve_acc <= '0';

      wait for 100 ns;
      --ADD B, R3!!!
      --le o que foi colocado no r3 pra ficar disponível na saída da ula
      qual_reg_le <= "0011"; 
      escolhe_accB <= '1'; --pra escolher o accB
      escreve_acc <= '1';
      escreve_banco <= '0';


      wait for 100 ns;
      escolhe_accB <= '0';
      escreve_acc <= '0';

      wait for 100 ns;
      --com cte ADDI B, 17!!!
      escolhe_accB <= '1';
      escreve_acc <= '1';
      op_com_cte <= '1';
      cte <= "0000000000010001";
      

      wait for 100 ns;
      escolhe_accB <= '0';
      op_com_cte <= '0';
      escreve_acc <= '0';

        --LD R6, 16
        --wait for 100 ns;
        --escreve_banco <= '1'; 
        --qual_reg_escreve <= "0110"; 
        --dado_escrita_banco <= "0000000000010000";
        --escolhe_accA <= '0';
        --escolhe_accB <= '0'; 
        --op_com_cte <= '0';

      --ADD A, R1
       --wait for 100 ns;
      --escolhe_accB <= '0';
      --op_com_cte <= '0';
      --escolhe_accA <= '0';
      --qual_reg_escreve <= "0001";
      --qual_reg_le <= "0001";
      --escolhe_accA <= '1';
      --sel0 <= '0';
      --sel1 <= '0'; 
      
      
      --wait for 100 ns;
       --AND B, 31
      --escolhe_accB <= '1';
      --op_com_cte <= '1';
      --escolhe_accA <= '0';
      --sel0 <= '0'; 
      --sel1 <= '1'; 
      --cte <="0000000000011111";
      --escreve_banco <= '0';

      --wait for 100 ns;
      --escolhe_accB <= '0';
      --op_com_cte <= '0';
      
      wait for 100 ns;
      --LD B, 9
      escolhe_accB <= '1';
      escreve_acc <= '1';
      op_ld_acc <= '1';
      dado_ext_escrita_acc <= "0000000000001001";

      wait for 100 ns;
      escolhe_accB <= '0';
      op_ld_acc <= '0';
      escreve_acc <= '0';

      wait for 100 ns;
      --MOV R3, B
      escolhe_accB <= '1';
      op_mov_p_reg <= '1';
      escreve_banco <= '1';
      qual_reg_escreve <= "0011"; 

      wait for 100 ns;
      qual_reg_le <= "0011";   
      escolhe_accB <= '0';
      op_mov_p_reg <= '0';
      escreve_banco <= '0'; 

    wait for 100 ns;
      --MOV A, R6
      qual_reg_le <= "0110";
      escolhe_accA <= '1';
      escreve_acc <= '1';
      op_mov_p_acc <= '1'; 

      wait for 100 ns;
      escolhe_accA <= '0';
      op_mov_p_acc <= '0';
      escreve_acc <= '0';

      wait;                    
   end process;


end architecture;