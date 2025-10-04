library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel is
    port (
        Clock : in std_logic;
        --descobrir quais as entradas e saídas que precisa
    );
end entity;

architecture struct of TopLevel is

    component reg16bits is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component BancoReg is
        port( 
            clk_b         : in std_logic;
            rst_b          : in std_logic; 
            wr_en         : in std_logic; 
            sel_reg_wr    : in unsigned(3 downto 0); 
            sel_reg_rd    : in unsigned(3 downto 0); 
            acc           : in std_logic; 
            data_wr       : in unsigned(15 downto 0); 
            data_out_r1   : out unsigned(15 downto 0) 
        );
    end component;

    component ULA is
        port(
            in_A, in_B : in unsigned(15 downto 0);
            Sel0, Sel1 : in std_logic;
            Resultado : out unsigned(15 downto 0);
            Carry, Overflow, Zero, Sinal : out std_logic
        );
    end component;

    signal -- os 430 sinais que precisa pra ligar 



begin

    uut0 : BancoReg port map (clk_b => Clock, rst_b => , wr_en => , sel_reg_wr => , sel_reg_rd => , acc => , data_wr => , data_out_r1 => );
    uut1 : ULA port map (in_A => , in_B => , Sel0 => , Sel1 => , Resultado => , Carry => , Overflow => , Zero => , Sinal => );
    uutA : reg16bits port map (clk => Clock, rst => , wr_en => , data_in => , data_out => ); --acumulador A/0
    uutB : reg16bits port map (clk => Clock, rst => , wr_en => , data_in => , data_out => ); --acumulador B/1

    process
    begin
        --os valores pros testes
    end process;

end struct ; 