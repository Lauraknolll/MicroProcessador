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
      --MOV destino, fonte

      0  => "1100001100000000", -- LD R3, 12 (A : Carrega R3 com 0)

      1  => "1100010000000000", -- LD R4, 8 (B : Carrega R4 com 0)

      2  => "1101100000001010", -- LD B, 10 (D: é o valor a ser comparado no BHI, carregado antes do loop)

      3  => "1110001001000000", -- MOV A, R4 (C : ADD R4, R3, R4)
      4  => "0100000110000000", -- ADD A, R3 (C)
      5  => "1110001000000000", -- MOV A, R4 (C) (R3 com R4 e guarda no R4)

      6  => "1110000111000000", -- MOV A, R3 (D: Soma 1 em R3)
      7  => "0010000000000001", -- ADDI R3,1 (D)
      8  => "1110000110000000", -- MOV R3, A (D)

      9  => "1001100110000000", -- COMP B,R3 (E: BHI B,R3, C)
      10 => "1011000001111001", -- BHI B, R3, -7 (E)

      11 => "1001100110000000", -- COMP B,R3 (F: BGE B,R3)
      12 => "1010000000000101",  --BGE B, R3, +5

      13 => "1111000000000010", -- JUMP 2 (H: Senão pular no BGE) 
      --14 => "0000000000000000",
      --15 => "0000000000000000",
      --16 => "0000000000000000",
      17 => "1100001100001111", -- LD R3, 15 (F: se BGE )
      --18 => "0000000000000000",
      --19 => "0000000000000000",
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

