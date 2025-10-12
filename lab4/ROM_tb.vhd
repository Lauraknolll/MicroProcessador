library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM_tb is
end;

architecture a_ROM_tb of ROM_tb is
    component ROM is
    port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
    );
    end component;

    signal CLK : std_logic;
    signal ENDERECO :  unsigned(6 downto 0);
    signal DADO     :  unsigned(15 downto 0);
    signal finished : std_logic;

    begin
        uutROM: ROM port map(clk => CLK, endereco => ENDERECO, dado => DADO);

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
                ENDERECO <= "0000000";
                wait for 100 ns;
                ENDERECO <= "0000001";
                wait for 100 ns;
                ENDERECO <= "0000010";
                wait for 100 ns;
                ENDERECO <= "0000011";
                wait for 100 ns;
                ENDERECO <= "0000100";
                wait for 100 ns;
                ENDERECO <= "0000101";
                wait for 100 ns;
                ENDERECO <= "0000110";
                wait for 100 ns;
                ENDERECO <= "0000111";
                wait for 100 ns;
                ENDERECO <= "0001000";
                wait for 100 ns;
                ENDERECO <= "0001001";
                wait for 100 ns;
                ENDERECO <= "0001010";
            wait;
            end process;

end architecture;