library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        in_A, in_B : in unsigned(15 downto 0);
        Sel0, Sel1 : in std_logic;
        Resultado : out unsigned(15 downto 0)
    );
end entity;

architecture struct of ULA is

    signal soma, subtracao, resand, resor : unsigned(15 downto 0);
begin
    soma <= in_A + in_B;
    subtracao <= in_A - in_B;
    resand <= in_A AND in_B;
    resor <= in_A OR in_B;

    resultado <= soma      when (Sel0 = '0' AND Sel1 = '0') else
                 subtracao when (Sel0 = '1' AND Sel1 = '0') else
                 resand    when (Sel0 = '0' AND Sel1 = '1') else
                 resor     when (Sel0 = '1' AND Sel1 = '1') else
                 "0000000000000000";
end architecture;