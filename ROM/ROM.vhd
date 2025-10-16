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
      0  => "0000000000001010",
      1  => "0000000000001011",
      2  => "0000000000001100",
      3  => "0000000000001101",
      4  => "0000000000001110",
      5  => "0000000000001111",
      6  => "0000000000010000",
      7  => "0000000000010001",
      8  => "0000000000010011",
      9  => "0000000000010100",
      10 => "0000000000010101",
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