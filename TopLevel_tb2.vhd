library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel_tb2 is
end entity;

architecture struct of TopLevel_tb2 is

    component TopLevel2 is
    port (
        clock : in std_logic;
        reset_acc : in std_logic;
        reset_pmu, reset_mqe, wr_mqe: in std_logic
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_accA, escolhe_accB, escreve_acc, sel0, sel1, carry, overflow, zero, sinal, finished, op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc  : std_logic;
    signal dado_ext_escrita_banco, dado_ext_escrita_acc, cte, saida_rom, INSTRU_GLOBAL : unsigned(15 downto 0); 
    signal qual_reg_escreve, qual_reg_le : unsigned(3 downto 0);
    -----
    signal reset_pmu, wr_pmu, reset_mqe, wr_mqe : std_logic;

begin
    uut : TopLevel2 port map (clock => clock, reset_acc => reset_acc, reset_pmu => reset_pmu, 
    reset_mqe => reset_mqe, wr_mqe => wr_mqe );

    reset_global: process
    begin
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

    process                      
    
    begin
      
      wait;                    
   end process;


end architecture;