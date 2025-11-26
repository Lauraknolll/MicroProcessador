library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        in_A, in_B : in unsigned(15 downto 0);
        Sel0, Sel1 : in std_logic;
        Resultado : out unsigned(15 downto 0);
        Carry, Overflow, Zero, Sinal : out std_logic
    );
end entity;

architecture struct of ULA is

    signal ResSoma, ResSubtracao, ResAND, ResOR : unsigned(15 downto 0);
    signal in_A_17, in_B_17, soma_17 : unsigned (16 downto 0); --pra pegar o bit a mais
    signal carry_soma, carry_subtr : std_logic;

begin
    ResSoma      <= in_A + in_B;
    ResSubtracao <= in_B - in_A; 
    ResAND       <= in_A AND in_B;
    ResOR        <= in_A OR in_B;

    Resultado <= ResSoma      when (Sel0 = '0' AND Sel1 = '0') else
                 ResSubtracao when (Sel0 = '1' AND Sel1 = '0') else
                 ResAND       when (Sel0 = '0' AND Sel1 = '1') else
                 ResOR        when (Sel0 = '1' AND Sel1 = '1');

    in_A_17 <= '0' & in_A;      -- passamos in_a para 17 bits
    in_B_17 <= '0' & in_B;      -- idem in_b
    soma_17 <= in_a_17 + in_b_17;
    
    carry_soma <= soma_17(16);  -- o carry eh o MSB da soma 17 bits

    carry_subtr <= '0' when in_A <= in_B else 
                   '1';

    Carry <= carry_soma when (Sel0 = '0' AND Sel1 = '0') else
             carry_subtr when (Sel0 = '1' AND Sel1 = '0');
    
    Overflow <= '1' when (Sel1='0' and Sel0='0' and (in_A(15) = in_B(15)) and (ResSoma(15) /= in_A(15)))  else --sinal dos operandos igual e sinal do resultado diferente
                '1' when (Sel1='1' and Sel0='0' and (in_A(15) /= in_B(15)) and (ResSubtracao(15) /= in_A(15))) else --sinal dos operando diferente e sinal do resultado diferente do A
                '0';

    Sinal <= ResSoma(15)      when (Sel0 = '0' AND Sel1 = '0') else
             ResSubtracao(15) when (Sel0 = '1' AND Sel1 = '0') else
             ResAND(15)      when (Sel0 = '0' AND Sel1 = '1') else
             ResOR(15)        when (Sel0 = '1' AND Sel1 = '1');

    Zero <= '1'              when (Sel0 = '0' AND Sel1 = '0' AND ResSoma = "0000000000000000") else
             '1'              when (Sel0 = '1' AND Sel1 = '0'AND ResSubtracao = "0000000000000000") else
             '1'              when (Sel0 = '0' AND Sel1 = '1'AND ResAND = "0000000000000000") else
             '1'              when (Sel0 = '1' AND Sel1 = '1'AND ResOR = "0000000000000000") else
             '0';

end architecture;