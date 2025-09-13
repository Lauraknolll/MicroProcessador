library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        in_A, in_B : in unsigned(15 downto 0);
        Sel0, Sel1 : in std_logic;
        Resultado : out unsigned(15 downto 0)
        Carry, Overflow, Zero, Sinal : out std_logic;
    );
end entity;

architecture struct of ULA is

    signal ResSoma, ResSubtracao, ResAND, ResOR : unsigned(15 downto 0);
begin
    ResSoma <= in_A + in_B;
    ResSubtracao <= in_A - in_B;
    ResAND <= in_A AND in_B;
    ResOR <= in_A OR in_B;

    resultado <= ResSoma      when (Sel0 = '0' AND Sel1 = '0') else
                 ResSubtracao when (Sel0 = '1' AND Sel1 = '0') else
                 ResAND    when (Sel0 = '0' AND Sel1 = '1') else
                 ResOR     when (Sel0 = '1' AND Sel1 = '1') else
                 "0000000000000000";
end architecture;