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

        --elementos do PC
        reset_pmu, reset_mqe, wr_mqe: in std_logic;
        instru : in unsigned(15 downto 0)
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_accA, escolhe_accB, escreve_acc, sel0, sel1, carry, overflow, zero, sinal, finished, op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc  : std_logic;
    signal dado_ext_escrita_banco, dado_ext_escrita_acc, cte, saida_rom, INSTRU_GLOBAL : unsigned(15 downto 0); 
    signal qual_reg_escreve, qual_reg_le : unsigned(3 downto 0);
    -----
    signal reset_pmu, wr_pmu, reset_mqe, wr_mqe : std_logic;

begin
    uut : TopLevel port map (clock => clock, dado_ext_escrita_banco => dado_ext_escrita_banco, reset_b => reset_b, reset_acc => reset_acc, 
    qual_reg_escreve => qual_reg_escreve, qual_reg_le => qual_reg_le, escreve_banco => escreve_banco, escolhe_accA => escolhe_accA, 
    escolhe_accB => escolhe_accB, escreve_acc => escreve_acc, dado_ext_escrita_acc => dado_ext_escrita_acc, op_com_cte => op_com_cte, 
    cte => cte, sel0 => sel0, sel1 => sel1, carry => carry, overflow => overflow, zero => zero, sinal => sinal, 
    op_mov_p_reg => op_mov_p_reg, op_mov_p_acc => op_mov_p_acc, op_ld_acc => op_ld_acc, reset_pmu => reset_pmu, reset_mqe => reset_mqe, wr_mqe => wr_mqe,
    instru => INSTRU_GLOBAL);

    reset_global: process
    begin
        wr_pmu <= '1';
        reset_b <= '1';
        reset_acc <= '1';
        reset_pmu <= '1';
        reset_mqe <= '1';
        wait for 100 ns; 
        reset_b <= '0';
        reset_acc <= '0';
        reset_pmu <= '0';
        reset_mqe <= '0';
        wr_mqe <= '1';
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
      end process;

end architecture;