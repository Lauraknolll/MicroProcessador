library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROMBRUNA is
   port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
   );
end entity;

architecture a_ROMBRUNA of ROMBRUNA is
   type mem is array (0 to 127) of unsigned(15 downto 0);
   constant conteudo_rom : mem := (
      -- caso endereco => conteudo
      --0  => "1000000000000000", -- nop
      --1  => "1000000000000000",-- nop
      --2  => "1111000000000100",-- jump para 4
      --3  => "1000000000000000",-- nop
      --4  => "1000000000000000", -- nop
      --5  => "1111000000000111",-- jump para 7
      --6  => "1000000000000000", -- nop
      --7  => "1111000000001010", -- jump pro 10 (loop)
      --8  => "1000000000000000",
      --9  => "1000000000000000",
      --10 => "1111000000000111", --j ump pro 7 (loop)
      --11 => "1000000000000000",
      0  => "0010000000000100", -- ADDI A, 4
      1  => "0010000000001000", -- ADDI A, 8
      2  => "0010100000010000",--ADDI B 16
      3  => "0011000000001110",--SUBI A, 14 -- é para te 2 como resultado
      4  => "0101110000000000",--SUB B, REG8
      5  => "0101110001111111",--SUB B, REG8
      6  => "0110100000000000", -- AND B, REG0
      7  => "0110001000000000", -- AND A, REG4
      8  => "1111100000001001",-- é jump e endereco 9
      9  => "1111111111000000", -- é jump e endereco 1000000
      10  => "1111011110010000", -- é jump e endereco 16
      11 => "1110111110000011", -- NÃO é jump e endereco 0000011
      16 => "0000000000000000",
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

--      0  => "1000000000000000", -- nop
--      1  => "1000000000000000",-- nop
--      2  => "1111000000000100",-- jump para 4
--      3  => "1000000000000000",--
--      4  => "1111000000000010",-- jump para 2
--      5  => "1000000000000000", -- nop
--      6  => "1000000000000000", -- nop
--      7  => "1111100000001001",-- é jump e endereco 9
--      8  => "1111000000010000", -- é jump e endereco 10000
--      9  => "1111000000000110", -- é jump e endereco 6
--      10 => "1110111110000011", -- NÃO é jump e endereco 0000011 --outra instrução qualquer
--      16 => "1000000000000000", --nopp
--      17 => "1000000000000000", --nopp
--      18 => "1000000000000000", --nopp
--      19 => "1111100000100000", --jump para endereço 32 (é zero)