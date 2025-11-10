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

      0  => "1100101000000111", -- LD R10, 7   
      1  => "1101100000000010", -- LD B, 2     
      2  => "1000000000000000", -- SW B, R7 para guardar na memória

      3  => "1100101000010000", -- LD R10, 16   
      4  => "1101100000000110", -- LD B, 6     
      5  => "1000000000000000", -- SW B, R7 para guardar na memória

      6  => "1100101000001010", -- LD R10, 10
      7  => "1101100000011010", -- LD B, 26     
      8  => "1000000000000000", -- SW B, R7 para guardar na memória

      9  => "1100101000010000", -- LD R10, 16   
      10 =>"1101100001000000", -- LD B, 64
      11 => "0001000000000000", -- LW B, R7 para LER na memória
      12 => "1110100000000000", -- MOV B, R0
      
      13 => "1100101000000111", -- LD R10, 7   
      14 => "1101100001000000", -- LD B, 64     
      15 => "0001000000000000", -- LW B, R7 para LER na memória
      16 => "1110100010000000", -- MOV B, R1

      17 => "1100101000001010", -- LD R10, 10   
      18 => "1101100001000000", -- LD B, 64   
      19 => "0001000000000000", -- LW B, R7 para LER na memória
      20 => "1110100100000000", -- MOV B, R2

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

