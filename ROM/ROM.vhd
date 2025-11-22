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

      --Colocar o 1024 no A
      0   => "1101000001111111", --LD A, 127
      1   => "0010000000000001", --ADDI A, 1
      2   => "1110001000000000", --MOV R4, A
      3   => "0100001000000000", --ADD A, R4
      4   => "1110001000000000", --MOV R4, A
      5   => "0100001000000000", --ADD A, R4        
      6   => "1110001000000000", --MOV R4, A
      7   => "0100001000000000", --ADD A, R4
      
      --Colocar 1 em todas as posições de 0 a 1023
      8   => "1100101000000000", --LD R10, 0
      9   => "1101100000000001", --LD B, 1
      10   => "1110010101000000", --MOV A, R10
      11  => "1001010100000000", --COMP A, R4 (o r4 tem 1024)
      12  => "1000000000000000", --SW (No endereço r10 o que tem no B)
      13  => "0100110100000000", --ADD B, R10
      14  => "1110110100000000", --MOV R10, B
      15  => "1101100000000001", --LD B, 1
      16  => "1010000001111010", --BGE (faz jump pro MOV A, R10)

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


      -- --LOOP ESCRITA NOS ENDEREÇOS PARES
      -- 0  => "1100101000000000", --LD r10, 0       --endereço 0
      -- 1  => "1101100000000101", --LD B, 5         -- valor 5
      -- 2  => "1101000000000000", --LD A, 0         --loop 
      -- 3  => "1100000001000000", --LD r0, 64       --loop 
      -- 4  => "1000000000000000", --SW 
      -- 5  => "0010100000000001", --ADDI B, 1       --aumenta o valor em 1
      -- 6  => "0010100000000001", --ADDI B, 1       --aumenta o valor em mais 1
      -- 7  => "1110100100000000", --MOV r2, B       --guarda o valor no r2
      -- 8  => "1110110101000000", --MOV B, r10      --coloca o endereco no B
      -- 9  => "0010100000000001", --ADDI B, 1       --vai pro próx endereço
      -- 10 => "0010100000000001", --ADDI B, 1      --vai pro próx endereço
      -- 11 => "1110110100000000", --MOV r10, B     --volta o endereço pro r10
      -- 12 => "1110100101000000", --MOV B, r2      --pega o valor de volta
      -- 13 => "0010000000000001", --ADDI A, 1      --faz o ++ do loop
      -- 14 => "1001000000000000", --COMP
      -- 15 => "1011100001110101", --BHI
      -- 16 => "0000000000000000",

      -- --LOOP ESCRITA DE 30 A 45 CONTÍNUO 
      -- 17 => "1100101000011110", --LD r10, 30     --endereço 30
      -- 18 => "1101100000000001", --LD B, 1        -- valor 1
      -- 19 => "1101000000000000", --LD A, 0        --loop 
      -- 20 => "1100000000001111", --LD r0, 4       --loop 
      -- 21 => "1000000000000000", --SW 
      -- 22 => "0010100000000001", --ADDI B, 1      --aumenta o valor em 1
      -- 23 => "1110100100000000", --MOV r2, B      --guarda o valor no r2
      -- 24 => "1110110101000000", --MOV B, r10     --coloca o endereco no B
      -- 25 => "0010100000000001", --ADDI B, 1      --vai pro próx endereço
      -- 26 => "1110110100000000", --MOV r10, B     --volta o endereço pro r10
      -- 27 => "1110100101000000", --MOV B, r2      --pega o valor de volta
      -- 28 => "0010000000000001", --ADDI A, 1      --faz o ++ do loop
      -- 29 => "1001000000000000", --COMP
      -- 30 => "1011100001110111", --BHI

      -- --ESCRITA ALEATÓRIA
      -- 31 => "1100101001101000", -- LD R10, 104  
      -- 32 => "1101100000111000", -- LD B, 56 
      -- 33 => "1000000000000000", -- SW

      -- --LOOP LEITURA
      -- 34 => "1100101000000000", --LD r10, 0     --endereço 0
      -- 35 => "1101000000000000", --LD A, 0       --loop 
      -- 36 => "1100000010000000", --LD r0, 128    --loop
      -- 37 => "0001000000000000", --LW
      -- 38 => "1110101010000000", --MOV r5, B     --guarda o valor que leu no r5
      -- 39 => "1110110101000000", --MOV B, r10    --coloca o endereco no B
      -- 40 => "0010100000000001", --ADDI B, 1     --vai pro próx endereço
      -- 41 => "1110110100000000", --MOV r10, B    --volta o endereço pro r10
      -- 42 => "0010000000000001", --ADDI A, 1     --faz o ++ do loop
      -- 43 => "1001000000000000", --COMP
      -- 44 => "1011100001110111", --BHI

