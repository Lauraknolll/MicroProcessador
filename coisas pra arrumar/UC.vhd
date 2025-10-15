library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
   port( 
        instrucao : in unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic;
        nop :out std_logic        
   );
end entity;

architecture a_UC of UC is
   signal opcode: unsigned(3 downto 0);
   signal  accs_ula,cte, dado_ula, dado_escrita_banco, dado_escrita_acc : unsigned(15 downto 0);

begin
   -- coloquei o opcode nos 4 bits MSB
   opcode <= instrucao(15 downto 12);
   -- meu jump: opcode 1111
   jump_en <=  '1' when opcode="1111" else
               '0';
    endereco_destino <= instrucao(6 downto 0) when opcode="1111" else
                        "0000000";
    

    nop<= '1' when opcode ="1000" else
            '0';

end architecture;