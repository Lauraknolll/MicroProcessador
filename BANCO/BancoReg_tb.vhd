library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoReg_tb is
end entity;

architecture aBancoReg_tb of BancoReg_tb is

    component BancoReg is          -- aqui vai seu componente a testar
        port( 
            clk_b      : in std_logic;
            rst_b          : in std_logic;
            wr_en         : in std_logic;
            sel_reg_wr    : in unsigned(3 downto 0);
            sel_reg_rd    : in unsigned(3 downto 0);
            data_wr       : in unsigned(15 downto 0);
            dado_out_b   : out unsigned(15 downto 0)
        );
    end component;

     -- 100 ns é o período que escolhi para o clock
    constant period_time          : time      := 100 ns;
    signal   finished             : std_logic := '0';
    signal   clk, reset, wr       : std_logic;
    signal reg_wr, reg_rd         :unsigned(3 downto 0);
    signal para_escrever, saida   : unsigned(15 downto 0 );
begin
    uut: BancoReg port map (clk_b => clk,rst_b => reset, wr_en => wr, sel_reg_wr => reg_wr, sel_reg_rd => reg_rd, data_wr => para_escrever, dado_out_b => saida);  -- aqui vai a instância do seu componente
    
    process
    begin
        --RESET    RESET     RESET    REST
        clk <= '0';
        reset <= '1';
        para_escrever <= "0000000000000001";
        wr <= '1';
        reg_wr <= "0001";
        wait for 50 ns;
        --RESET    RESET     RESET    REST
        clk <= '1';
        reset <= '1';
        wr <= '1';
        reg_wr <= "0001";
        wait for 50 ns;


        --escrevendo  9 no registrador 1
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000001001";
        wr <= '1';
        reg_wr <= "0001";
        reg_rd <= "0001";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000001001";
        wr <= '1';
        reg_wr <= "0001";
        reg_rd <= "0001";
        wait for 50 ns;
        
        --escrevendo 4 no registrador 2
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000000100";
        wr <= '1';
        reg_wr <= "0010";
        reg_rd <= "0010";
        wait for 50 ns;
        
        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000000100";
        wr <= '1';
        reg_wr <= "0010";
        reg_rd <= "0010";
        wait for 50 ns;


        --consultando o valor do registrador 3
         clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000000100";
        wr <= '0';
        reg_wr <= "0000";
        reg_rd <= "0011";

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000000100";
        wr <= '0';
        reg_wr <= "0000";
        reg_rd <= "0011";
        wait for 50 ns;


        --escrevendo 1 no registrador 0  e CONSULTANTO O REGISTRADOR 2
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000000001";
        wr <= '1';
        reg_wr <= "0000";
        reg_rd <= "0010";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000000001";
        wr <= '1';
        reg_wr <= "0000";
        reg_rd <= "0010";
        wait for 50 ns;


        --CONSULTANDO O REGISTRADOR 1
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr <= '0';
        reg_wr <= "0001";
        reg_rd <= "0001";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr<= '0';
        reg_wr <= "0011";
        reg_rd <= "0001";
        wait for 50 ns;


        --escrevendo no registrador 3 e consultando o registrador 0
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000010000";
        wr<= '1';
        reg_wr <= "0011";
        reg_rd <= "0000";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000010000";
        wr<= '1';
        reg_wr <= "0011";
        reg_rd <= "0000";
        wait for 50 ns;
        
        --consultando o registrador 1
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr<= '0';
        reg_wr <= "0011";
        reg_rd <= "0001";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr<= '0';
        reg_wr <= "0011";
        reg_rd <= "0001";
        wait for 50 ns;


        --consultando o registrador 2
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000001001";
        wr<= '0';
        reg_wr <= "0011";
        reg_rd <= "0010";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr<= '0';
        reg_wr <= "0011";
        reg_rd <= "0010";
        wait for 50 ns;

        --consultando o registrador 3
        clk <= '0';
        reset <= '0';
        para_escrever <= "0000000000001001";
        wr<= '0';
        reg_wr <= "0000";
        reg_rd <= "0011";
        wait for 50 ns;

        clk <= '1';
        reset <= '0';
        para_escrever <= "0000000000001111";
        wr<= '0';
        reg_wr <= "0000";
        reg_rd <= "0011";
        wait for 50 ns;
        wait;
    end process;

end architecture aBancoReg_tb;