library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_tb is
end;

architecture a_RAM_tb of RAM_tb is

    component RAM is
    port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        wr_en    : in std_logic;
        dado_in  : in unsigned(15 downto 0);
        dado_out : out unsigned(15 downto 0) 
    );
    end component;

    signal CLK, WR_EN : std_logic;
    signal ENDERECO :  unsigned(6 downto 0);
    signal DADO_IN, DADO_OUT     :  unsigned(15 downto 0);
    signal finished : std_logic;

begin

    uutRAM : RAM port map(clk => CLK, endereco => ENDERECO, wr_en => WR_EN, dado_in => DADO_IN, dado_out => DADO_OUT);

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
        --escrever na posicao 1 o número 5
        DADO_IN <= "0000000000000101"; --5
        ENDERECO <= "0000001"; --1
        WR_EN <= '1';

        wait for 200 ns;     

        DADO_IN <= "0000000000000111"; --7
        ENDERECO <= "0001000"; --8

        wait for 200 ns;

        DADO_IN <= "0000000000000011"; --3
        ENDERECO <= "0010000"; --16

        wait for 200 ns;

        WR_EN <= '0';
        ENDERECO <= "0000000"; --0

        wait for 200 ns;

        ENDERECO <= "0010000"; --16

        wait for 200 ns;

        ENDERECO <= "0000001"; --1

        wait for 200 ns;

        ENDERECO <= "0001000"; --8

        wait for 200 ns;

    wait;
    end process;

end ;