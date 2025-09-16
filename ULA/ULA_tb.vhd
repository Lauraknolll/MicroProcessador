library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture struct of ULA_tb is

component ULA is
 port(
    in_A, in_B : in unsigned(15 downto 0);
    Sel0, Sel1 : in std_logic;
    Resultado : out unsigned(15 downto 0);
    Carry, Overflow, Zero, Sinal : out std_logic
);
end component;

signal in_a, in_b, res : unsigned(15 downto 0);
signal sel0, sel1, carry, overflow, zero, negativo : std_logic;

begin
    uut : ULA port map (in_A => in_a, in_B => in_b, Sel0 => sel0, Sel1 => sel1, Resultado => res,
                        Carry => carry, Overflow => overflow, Zero => zero, Sinal => negativo);
    process
    begin
        --soma os dois positivos
        in_A <= "0000000000000001";
        in_B <= "0000000000000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --soma os dois negativos
        in_A <= "1111111111111001";
        in_B <= "1111111000000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --soma os dois positivos com overflow
        in_A <= "0110000000000001";
        in_B <= "0111111110000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --soma os dois negativos com overflow
        in_A <= "1000000001100001";
        in_B <= "1111011100000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --soma negativo e positivo
        in_A <= "1111000000001001";
        in_B <= "0000001100000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --subtracao os dois positivos
        in_A <= "0000001100001110";
        in_B <= "0000000000101001";
        Sel0 <= '1';
        Sel1 <= '0';
        wait for 50 ns;
        --subtracao os dois negativos 
        in_A <= "1000001100001110";
        in_B <= "1111111111101001";
        Sel0 <= '1';
        Sel1 <= '0';
        wait for 50 ns;
        --subtracao os dois negativos
        in_A <= "1000000000000000";
        in_B <= "1111000000101001";
        Sel0 <= '1';
        Sel1 <= '0';
        wait for 50 ns;
        --subtracao com overflow
        in_A <= "1000000000000000";
        in_B <= "0111111100101001";
        Sel0 <= '1';
        Sel1 <= '0';
        wait for 50 ns;
        --and com zero
        in_A <= "0000000000000001";
        in_B <= "0000000000000010";
        Sel0 <= '0';
        Sel1 <= '1';
        wait for 50 ns;
        --and "positivos"
        in_A <= "0000000100101000";
        in_B <= "0000000100001011";
        Sel0 <= '0';
        Sel1 <= '1';
        wait for 50 ns;
        --and "negativos"
        in_A <= "1110000100101000";
        in_B <= "1000000100001011";
        Sel0 <= '0';
        Sel1 <= '1';
        wait for 50 ns;
        --or "positivos"
        in_A <= "0001010100001100";
        in_B <= "0000000100000011";
        Sel0 <= '1';
        Sel1 <= '1';
        wait for 50 ns;
        --or "positivos"
        in_A <= "0000000000000000";
        in_B <= "0000000100000011";
        Sel0 <= '1';
        Sel1 <= '1';
        wait for 50 ns;
        --or "negativo"
        in_A <= "0000000000000000";
        in_B <= "1110000100000011";
        Sel0 <= '1';
        Sel1 <= '1';
        wait for 50 ns;
        wait;
    end process;

end struct ; 