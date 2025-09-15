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
begin
    ResSoma      <= in_A + in_B;
    ResSubtracao <= in_A - in_B;
    ResAND       <= in_A AND in_B;
    ResOR        <= in_A OR in_B;

    -------Carry <= '1' when (((ResSoma<in_A) OR (ResSoma<in_B)) AND (Sel0 = '0' AND Sel1 = '0') ) else
    --Carry <= '1' when (((in_A(15)='0') AND (in_B(15)='0')) AND (Sel0 = '0' AND Sel1 = '0') AND (ResSoma(15)='1')) else
           -- '0';
    Carry<='0';
   --Overflow <= '1' when (((in_A(15)='0')AND (in_B(15)='0')) AND ((in_A + in_B)(15)='1')) else
                --'1' when (((in_A(15)='1')AND (in_B(15)='1')) AND ((in_A + in_B)(15)='0')) else
               -- '0';
    Overflow <= '1' when ((in_A(15) = '0') and (in_B(15) = '0') and (ResSoma(15) = '1') and (Sel0 = '0' AND Sel1 = '0') ) else
                '1' when ((in_A(15) = '1') and (in_B(15) = '1') and (ResSoma(15) = '0') and (Sel0 = '0' AND Sel1 = '0')) else
                '1' when ((in_A(15) = '0') and (not(in_B(15)) = '0') and (ResSubtracao(15) = '1') and (Sel0 = '1' AND Sel1 = '0') ) else
                '1' when ((in_A(15) = '1') and (not(in_B(15)) = '1') and (ResSubtracao(15) = '0') and (Sel0 = '1' AND Sel1 = '0')) else
                '0';
        
    resultado <= ResSoma      when (Sel0 = '0' AND Sel1 = '0') else
                 ResSubtracao when (Sel0 = '1' AND Sel1 = '0') else
                 ResAND       when (Sel0 = '0' AND Sel1 = '1') else
                 ResOR        when (Sel0 = '1' AND Sel1 = '1') else
                 "0000000000000000";
   -- Sinal<= (in_A + in_B)(15)      when (Sel0 = '0' AND Sel1 = '0') else
     --       (in_A - in_B)(15) when (Sel0 = '1' AND Sel1 = '0') else
       --     (in_A AND in_B)(15)      when (Sel0 = '0' AND Sel1 = '1') else
         --   (in_A OR in_B)(15)        when (Sel0 = '1' AND Sel1 = '1') else
           -- '0';
    Sinal<= ResSoma(15)      when (Sel0 = '0' AND Sel1 = '0') else
            ResSubtracao(15) when (Sel0 = '1' AND Sel1 = '0') else
            ResAND(15)      when (Sel0 = '0' AND Sel1 = '1') else
            ResOR(15)        when (Sel0 = '1' AND Sel1 = '1') else
            '0';
     Zero <= '1'              when (Sel0 = '0' AND Sel1 = '0' AND (ResSoma=0)) else
            '1'              when (Sel0 = '1' AND Sel1 = '0'AND (ResSubtracao=0)) else
            '1'              when (Sel0 = '0' AND Sel1 = '1'AND (ResAND=0)) else
            '1'              when (Sel0 = '1' AND Sel1 = '1'AND (REsOR=0)) else
            '0';
    --Zero <= '1'              when (Sel0 = '0' AND Sel1 = '0' AND ((in_A + in_B)=0)) else
      --      '1'              when (Sel0 = '1' AND Sel1 = '0'AND ((in_A - in_B)=0)) else
        --    '1'              when (Sel0 = '0' AND Sel1 = '1'AND ((in_A AND in_B)=0)) else
          --  '1'              when (Sel0 = '1' AND Sel1 = '1'AND ((in_A OR in_B)=0)) else
            --'0';
end architecture;