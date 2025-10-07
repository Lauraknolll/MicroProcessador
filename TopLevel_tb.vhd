library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel_tb is
end entity;

architecture struct of TopLevel_tb is

    component TopLevel is
    port (
        clock : in std_logic;
        dado_escrita_banco : in unsigned(15 downto 0);
        reset_b, reset_acc : in std_logic; --o reset dos dois acumuladores é o mesmo??
        qual_reg_escreve, qual_reg_le : in unsigned(3 downto 0); --no banco
        escreve_banco : in std_logic;

        escolhe_accA, escolhe_accB : in std_logic; --se for 1 escolhe o accA, se for 0 escolhe o accB

        op_com_cte : in std_logic; --se for 1 é ADDI ou SUBI 
        cte : in unsigned(15 downto 0); --a cte que vem da instrução

        sel0, sel1 : in std_logic; --operações da ula
        carry, overflow, zero, sinal : out std_logic
        --descobrir quais as entradas e saídas que precisa
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_accA, escolhe_accB, sel0, sel1, carry, overflow, zero, sinal, finished, op_com_cte : std_logic;
    signal dado_escrita_banco, cte : unsigned(15 downto 0);
    signal qual_reg_escreve, qual_reg_le : unsigned(3 downto 0);

begin
    uut : TopLevel port map (clock => clock, dado_escrita_banco => dado_escrita_banco, reset_b => reset_b, reset_acc => reset_acc, 
    qual_reg_escreve => qual_reg_escreve, qual_reg_le => qual_reg_le, escreve_banco => escreve_banco, escolhe_accA => escolhe_accA, 
    escolhe_accB => escolhe_accB, op_com_cte => op_com_cte, cte => cte, sel0 => sel0, sel1 => sel1, carry => carry, overflow => overflow, 
    zero => zero, sinal => sinal);

    reset_global: process
    begin
        reset_b <= '1';
        reset_acc <= '1';
        wait for 100 ns; 
        reset_b <= '0';
        reset_acc <= '0';
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
      --ADD A, R3!!!!
      --coloco 7 no r3
      escreve_banco <= '1'; 
      qual_reg_escreve <= "0011"; 
      dado_escrita_banco <= "0000000000000111"; 
      --seta as coisas em zero pra não ficar indefinido
      escolhe_accA <= '0';
      escolhe_accB <= '0'; 
      op_com_cte <= '0';

      wait for 100 ns;
      --leio o r3
      sel0 <= '0'; --só pra dizer que fica fazendo soma
      sel1 <= '0';  
      escolhe_accA <= '1'; --escolho o accA pra somar com o r3 
      qual_reg_le <= "0011";   
      
      wait for 100 ns;
      escolhe_accA <= '0'; --desabilito ele porque já usei

      wait for 100 ns;
      --ADD A, r6!!!
      --coloco 5 no r6
      escreve_banco <= '1'; 
      qual_reg_escreve <= "0110"; 
      dado_escrita_banco <= "0000000000000101"; 

      wait for 100 ns;
      --le o que foi colocado no r6
      qual_reg_le <= "0110"; 
      escolhe_accA <= '1'; --escolho o accA    

      wait for 100 ns;
      escolhe_accA <= '0';

      wait for 100 ns;
      --ADD B, r3!!!
      --le o que foi colocado no r3 pra ficar disponível na saída da ula
      qual_reg_le <= "0011"; 
      escolhe_accB <= '1'; --pra escolher o accB

      wait for 100 ns;
      escolhe_accB <= '0';

      wait for 100 ns;
      --com cte ADDI B, 17!!!
      escolhe_accB <= '1';
      op_com_cte <= '1';
      cte <= "0000000000010001";

      wait for 100 ns;
      escolhe_accB <= '0';
      op_com_cte <= '0';

      --LD r6, 16
     wait for 100 ns;
      escreve_banco <= '1'; 
      qual_reg_escreve <= "0110"; 
      dado_escrita_banco <= "0000000000010000";
      escolhe_accA <= '0';
      escolhe_accB <= '0'; 
      op_com_cte <= '0';

      --ADD A, r1
       wait for 100 ns;
      escolhe_accB <= '0';
      op_com_cte <= '0';
      escolhe_accA <= '0';
      --qual_reg_escreve <= "0001";
      qual_reg_le <= "0001";
      escolhe_accA <= '1';
      sel0 <= '0';
      sel1 <= '0'; 
      
      
      wait for 100 ns;
       --AND B, r3
      escolhe_accB <= '1';
      op_com_cte <= '0';
      qual_reg_le <= "0011";
      escolhe_accA <= '0';
      sel0 <= '0'; 
      sel1 <= '1'; 
      --cte <="0000000000011111";
      escreve_banco <= '0';

      wait;                    
   end process;


end architecture;