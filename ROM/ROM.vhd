library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of unsigned(15 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      0  => "1100001100000101", -- LD R3, 5 (A : Carrega R3 com 5)

      1  => "1100010000001000", -- LD R4, 8 (B : Carrega R4 com 8)

      2  => "1110000111000000", -- MOV DO R3 PRO A (C : Soma R3 com R4 e guarda em R5)
      3  => "0100001000000000", -- ADD A, R4 (C)
      4  => "1110001010000000", -- MOV DO A PRO R5 (C)

      5  => "0011000000000001", -- SUBI A, 1 (D : Subtrai 1 de R5)
      6  => "1110001010000000", -- MOV DO A PRO R5 (D)

      7  => "1111000000010100", -- JUMP pra 20 (E : Salta para o endereço 20)
      8  => "1100010100000000", -- LD R5, 0 (F : Zera R5)
      9  => "0000000000000000", -- NOP
      10 => "0000000000000000",
      11 => "0000000000000000",
      12 => "0000000000000000",
      13 => "0000000000000000",
      14 => "0000000000000000",
      15 => "0000000000000000",
      16 => "0000000000000000",
      17 => "0000000000000000",
      18 => "0000000000000000",
      19 => "0000000000000000",
      20 => "1110000110000000", -- MOV DO A (Q TEM R5) PRO R3 (G : copia R5 para R3)

      21 => "1111000000000010", -- JUMP pra 2 (H : Salta para o passo C)

      22 => "1100001100000000", -- LD R3, 0 (I : Zera R3)
      -- abaixo: casos omissos => (zero em todos os bits)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;

