library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel2_tb is
end entity;

architecture struct of TopLevel2_tb is

    component TopLevel2 is
    port (
        clock : in std_logic;
        reset_pmu, reset_uc, wr_uc: in std_logic
    );
    end component;
    signal reset_pmu, reset_uc, wr_uc, clock, finished : std_logic;

begin
    uut : TopLevel2 port map (clock => clock, reset_pmu => reset_pmu, reset_uc => reset_uc, wr_uc => wr_uc );

    reset_global: process
    begin
        reset_pmu <= '1';
        reset_uc <= '1';
        wait for 100 ns; 
        reset_pmu <= '0';
        reset_uc <= '0';
        wr_uc <= '1';
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