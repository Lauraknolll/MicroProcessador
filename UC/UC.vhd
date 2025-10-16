library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
   port( 
      clock, reset, wr : in std_logic;
      funciona_pc : out std_logic;
      ---
      instrucao : in unsigned(15 downto 0);
      endereco_destino: out unsigned(6 downto 0); --esta assim no top level
      jump_en : out std_logic;
      nop :out std_logic        
   );
end entity;

architecture a_UC of UC is
       
   component reg1bit is
      port( 
         clk      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_out : out std_logic
      );
   end component;

   signal opcode: unsigned(3 downto 0);
   signal estado : std_logic;

begin

   maq_estados : reg1bit port map (clk => clock, rst => reset, wr_en => wr, data_out => estado);
    
    --só atualiza o pc em 1
   funciona_pc <= '1' when (estado = '1') else
             '0'; 
   
   -- coloquei o opcode nos 4 bits MSB
   opcode <= instrucao(15 downto 12);
   -- meu jump: opcode 1111
   jump_en <=  '1' when opcode="1111" else
               '0';
   endereco_destino <= instrucao(6 downto 0) when opcode="1111" else
                        "0000000";
   nop <= '1' when opcode ="1000" else
            '0';

end architecture;