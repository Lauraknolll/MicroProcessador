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
    Resultado : out unsigned(15 downto 0)
);
end component;

signal in_a, in_b, res : unsigned(15 downto 0);
signal sel0, sel1 : std_logic;

begin
    uut : ULA port map (in_A => in_a, in_B => in_b, Sel0 => sel0, Sel1 => sel1, Resultado => res);
    process
    begin
        --soma
        in_A <= "0000000000000001";
        in_B <= "0000000000000010";
        Sel0 <= '0';
        Sel1 <= '0';
        wait for 50 ns;
        --subtracao
        in_A <= "0000001100001110";
        in_B <= "0000000000101001";
        Sel0 <= '1';
        Sel1 <= '0';
        wait for 50 ns;
        --and
        in_A <= "0000000000000001";
        in_B <= "0000000000000001";
        Sel0 <= '0';
        Sel1 <= '1';
        wait for 50 ns;
        in_A <= "0000000100101000";
        in_B <= "0000000100001011";
        Sel0 <= '0';
        Sel1 <= '1';
        wait for 50 ns;
        --or
        in_A <= "0001010100001100";
        in_B <= "0000000100000011";
        Sel0 <= '1';
        Sel1 <= '1';
        wait for 50 ns;
        in_A <= "0000000000000000";
        in_B <= "0000000100000011";
        Sel0 <= '1';
        Sel1 <= '1';
        wait for 50 ns;
        wait;
    end process;

end struct ; 