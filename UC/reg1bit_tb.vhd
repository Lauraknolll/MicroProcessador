library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg1bit_tb is
end entity;

architecture struct of reg1bit_tb is

    component reg1bit is
    port( clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_out : out std_logic
    );
    end component;

    signal CLK, RST, WR_EN, DATA_OUT, finished: std_logic;
begin
     uutT: reg1bit port map ( clk => CLK, rst => RST, wr_en => WR_EN, data_out => DATA_OUT);
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
            RST <= '1';
            wait for 200 ns;
            WR_EN<='1';
            RST <= '0';
            wait;
    end process;
end architecture;

