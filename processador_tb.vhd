library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is

    component TopLevel is
    port (
        clock : in std_logic;
        reset_b, reset_UC, reset_acc, reset_pmu, reset_mqe, reset_ir, wr_mqe : in std_logic
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_accA, escolhe_accB, escreve_acc, sel0, sel1, carry, overflow, zero, sinal, finished, op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc  : std_logic;
    -----
    signal reset_pmu, wr_pmu, reset_mqe, wr_mqe, reset_UC, reset_ir : std_logic;

begin
    uut : TopLevel port map (clock => clock,  reset_b => reset_b, reset_UC => reset_UC, reset_acc => reset_acc, 
    reset_pmu => reset_pmu, reset_mqe => reset_mqe, wr_mqe => wr_mqe, reset_ir => reset_ir);

    reset_global: process
    begin
        reset_b <= '1';
        reset_acc <= '1';
        reset_pmu <= '1';
        reset_mqe <= '1';
        reset_UC <= '1';
        reset_ir <= '1';
        wait for 100 ns;
         
        reset_UC <= '0';
        reset_b <= '0';
        reset_acc <= '0';
        reset_pmu <= '0';
        reset_mqe <= '0';
        wr_mqe <= '1';
        reset_ir <= '0';
        wait for 100 ns;
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 20 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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

end architecture;