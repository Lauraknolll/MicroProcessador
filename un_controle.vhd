library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
   port( 
        instrucao : in unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic
   );
end entity;

architecture a_un_controle of un_controle is
   signal opcode: unsigned(3 downto 0);
begin
   -- coloquei o opcode nos 4 bits MSB
   opcode <= instrucao(15 downto 12);
   -- meu jump: opcode 1111
   jump_en <=  '1' when opcode="1111" else
               '0';
    endereco_destino <= instrucao(6 downto 0) when opcode="1111" else
                        "0000000";
end architecture;