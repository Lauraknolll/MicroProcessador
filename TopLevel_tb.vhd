library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel_tb is
end entity;

architecture struct of TopLevel_tb is

    component TopLevel is
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
    end component;

    signal 

begin

    process
    begin
    end process;

end architecture;