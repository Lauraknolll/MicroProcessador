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

       --LD r10, 0 --começa do endereço 0
      --LD B, 5 --começa colocando o valor 5
      0 => "1101000000000001", --LD A, 1--pro loop 
      1 => "1100000000001000", --LD r0, 8 --pro loop 
      --SW 
      --ADDI B, 1 --aumenta o valor em 1
      --ADDI B, 1 --aumenta o valor em mais um
      --MOV r2, B --coloca o valor no r2
      --MOV B, r10 --coloco o endereco no B
      --ADDI B, 1 --vai pro próx endereço
      --MOV r10, B --volta pro r10
      2 => "1001000000000000", --COMP
      3 => "0010000000000001", --ADDI A, 1 --faz o ++ do loop
      4 => "1011100001111110", --BHI
      5 => "0000000000000000",

      

      -- 0  => "1100101000000111", -- LD R10, 7   
      -- 1  => "1101100000000010", -- LD B, 2     
      -- 2  => "1000000000000000", -- SW B, R10 para guardar na memória

      -- 3  => "1100101000010000", -- LD R10, 16   
      -- 4  => "1101100000000110", -- LD B, 6     
      -- 5  => "1000000000000000", -- SW B, R10 para guardar na memória

      -- 6  => "1100101000001010", -- LD R10, 10
      -- 7  => "1101100000011010", -- LD B, 26     
      -- 8  => "1000000000000000", -- SW B, R10 para guardar na memória

      -- 9  => "1100101000010000", -- LD R10, 16   
      -- 10 =>"1101100001000000", -- LD B, 64
      -- 11 => "0001000000000000", -- LW B, R10 para LER na memória
      -- 12 => "1110100000000000", -- MOV B, R0
      
      -- 13 => "1100101000000111", -- LD R10, 7   
      -- 14 => "1101100001000000", -- LD B, 64     
      -- 15 => "0001000000000000", -- LW B, R10 para LER na memória
      -- 16 => "1110100010000000", -- MOV B, R1

      -- 17 => "1100101000001010", -- LD R10, 10   
      -- 18 => "1101100001000000", -- LD B, 64   
      -- 19 => "0001000000000000", -- LW B, R10 para LER na memória
      -- 20 => "1110100100000000", -- MOV B, R2

      -- 21 => "1100101000001010", -- LD R10, 10   
      -- 22 => "1101100000111000", -- LD B, 56 
      -- 23 => "1000000000000000", -- SW B, R10 para LER na memória

      -- 24 => "1100101000001010", -- LD R10, 10   
      -- 25 => "1101100001000000", -- LD B, 64   
      -- 26 => "0001000000000000", -- LW B, R10 para LER na memória
      -- 27 => "1110100110000000", -- MOV B, R3

      -- 28 => "1100101000001010", -- LD R10, 10   
      -- 29 => "1101100000011110", -- LD B, 30 
      -- 30 => "1000000000000000", -- SW B, R10 para LER na memória

      -- 31 => "1100101000001010", -- LD R10, 10   
      -- 32 => "1101100001000000", -- LD B, 64   
      -- 33 => "0001000000000000", -- LW B, R10 para LER na memória
      -- 34 => "1110101000000000", -- MOV B, R4

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

