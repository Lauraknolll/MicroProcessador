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
      0  => "1000000000000000", -- nop
      1  => "1000000000000000",-- nop
      2  => "1111000000000100",-- jump para 4
      3  => "0000000000000000",--SUB B, REG8
      4  => "1000000000000000",-- nop
      5  => "1000000000000000", -- nop
      6  => "1000000000000000", -- nop
      7  => "1111100000001001",-- é jump e endereco 9
      8  => "1111111111000000", -- é jump e endereco 1000000
      9  => "1111000000000110", -- é jump e endereco 6
      10 => "1110111110000011", -- NÃO é jump e endereco 0000011
      16 => "1000000000000000", --nopp
      17 => "1000000000000000", --nopp
      18 => "1000000000000000", --nopp
      19 => "1111100000100000", --jump para endereço 32 (é zero)
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