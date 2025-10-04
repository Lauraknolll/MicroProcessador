library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel is
    port (
        clock : in std_logic;
        dado_escrita_banco : in std_logic;
        reset_b, reset_acc : in std_logic; --o reset dos dois acumuladores é o mesmo??
        qual_reg_escreve, qual_reg_le : in unsigned(3 downto 0); --no banco
        escreve_banco : in std_logic;

        escolhe_acc : in std_logic; --se for 1 escolhe o accA, se for 0 escolhe o accB

        sel0, sel1 : in std_logic; --operações da ula
        carry, overflow, zero, sinal : out std_logic
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

    signal banco_ula, ula_accs, acc0_ula, acc1_ula, accs_ula : unsigned(15 downto 0);

begin

    uut0 : BancoReg port map (clk_b => clock, rst_b => reset_b, wr_en => escreve_banco, sel_reg_wr => qual_reg_escreve, sel_reg_rd => qual_reg_le, acc => '0', data_wr => dado_escrita_banco, data_out_r1 => banco_ula);
    uutA : reg16bits port map (clk => clock, rst => reset_acc, wr_en => escolhe_acc, data_in => ula_accs, data_out => acc0_ula); --acumulador A/0
    uutB : reg16bits port map (clk => clock, rst => reset_acc, wr_en => not(escolhe_acc), data_in => ula_accs, data_out => acc1_ula); --acumulador B/1
    accs_ula <= acc0_ula when escolhe_acc else acc1_ula; --será que é o mesmo sinal do wr deles?
    uut1 : ULA port map (in_A => banco_ula, in_B => accs_ula, Sel0 => sel0, Sel1 => sel1, Resultado => ula_accs, Carry => carry, Overflow => overflow, Zero => zero, Sinal => sinal);

    process
    begin
        --os valores pros testes
    end process;

end struct ; 