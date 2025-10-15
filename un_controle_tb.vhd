library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle_tb is
end entity;

architecture struct of un_controle_tb is

    component un_controle is
    port( 
        instrucao : in unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic
   );
    end component;

    signal  JUMP_EN, CLK, finished: std_logic;
    signal INSTRU: unsigned (15 downto 0);
    signal ENDERECO: unsigned (6 downto 0);


begin
     uutT: un_controle port map ( instrucao => INSTRU, endereco_destino => ENDERECO, jump_en => JUMP_EN);
     
     sim_time_proc: process
    begin
        wait for 1 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO!!!
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

