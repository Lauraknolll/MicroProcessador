library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel_tb is
end entity;

architecture struct of TopLevel_tb is

    component TopLevel is
    port (
        clock : in std_logic;
        dado_escrita_banco : in unsigned(15 downto 0);
        reset_b, reset_acc : in std_logic; --o reset dos dois acumuladores é o mesmo??
        qual_reg_escreve, qual_reg_le : in unsigned(3 downto 0); --no banco
        escreve_banco : in std_logic;

        escolhe_acc0 : in std_logic; --se for 1 escolhe o accA, se for 0 escolhe o accB

        sel0, sel1 : in std_logic; --operações da ula
        carry, overflow, zero, sinal : out std_logic
        --descobrir quais as entradas e saídas que precisa
    );
    end component;

    signal clock, reset_b, reset_acc, escreve_banco, escolhe_acc0, sel0, sel1, carry, overflow, zero, sinal : std_logic;
    signal dado_escrita_banco : unsigned(15 downto 0);
    signal qual_reg_escreve, qual_reg_le : unsigned(3 downto 0);

begin
    uut : TopLevel port map (clock => clock, dado_escrita_banco => dado_escrita_banco, reset_b => reset_b, reset_acc => reset_acc, qual_reg_escreve => qual_reg_escreve, qual_reg_le => qual_reg_le,
    escreve_banco => escreve_banco, escolhe_acc0 => escolhe_acc0, sel0 => sel0, sel1 => sel1, carry => carry, overflow => overflow, zero => zero, sinal => sinal);

    reset_global: process
    begin
        reset_b <= '1';
        reset_acc <= '1';
        wait for 100 ns; -- espera 2 clocks, pra garantir
        reset_b <= '0';
        reset_acc <= '0';
        wait for 100 ns;
        wait;
    end process;

end architecture;