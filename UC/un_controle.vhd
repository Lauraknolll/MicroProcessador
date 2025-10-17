library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
   port( 
        instrucao : in unsigned(15 downto 0);
        acc0_ula : in unsigned(15 downto 0);
        acc1_ula : in unsigned(15 downto 0);
        banco_ula_UC : in unsigned(15 downto 0);
        acc_p_ula : out unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        eh_jump : out std_logic;
        sel0_ULA : out std_logic;
        sel1_ULA : out std_logic;
        wr_en_accA_UC : out std_logic;
        wr_en_accB_UC : out std_logic;
        nop :out std_logic;
        qual_reg_op : out unsigned (3 downto 0)
        
   );
end entity;

architecture a_un_controle of un_controle is
   signal opcode: unsigned(3 downto 0);
   signal  accs_ula,cte, dado_ula, dado_escrita_banco, dado_escrita_acc : unsigned(15 downto 0);
   signal escolhe_accA :  std_logic;
   signal  escolhe_accB :  std_logic;
   signal  op_com_cte :  std_logic;

begin
   -- coloquei o opcode nos 4 bits MSB
   opcode <= instrucao(15 downto 12);

   -- jump: opcode 1111
   eh_jump <=  '1' when opcode = "1111" else
               '0';
   endereco_destino <= instrucao(6 downto 0) when opcode="1111" else
                     "0000000";

   -- O bit 11 define qual acc será usado, 0 para o A e 1 para o B
   escolhe_accA <= not(instrucao(11)); --and (not(opcode = "1101"))and (not(opcode = "1100")) -- não é MOV nem LD
   escolhe_accB <= instrucao(11); 

   sel0_ULA <='0' when (opcode = "0100" OR opcode = "0010" or opcode = "0110") else --ADD OU ADDI ou AND
               '1';
   sel1_ULA <='0' when (opcode = "0101" OR opcode = "0011" or opcode = "0010" or opcode = "0100") else --SUB OU SUBI ou ADD ou ADDi
               '1';

   cte <= ("00000" & instrucao(10 downto 0)) when (opcode="0010") else -- ADDI
         ("00000" & instrucao(10 downto 0)) when (opcode="0011") else --SUBI
         ("00000" & instrucao(10 downto 0)) when (opcode="1101") else --LD ACC
         ("00000000" & instrucao(7 downto 0)) when (opcode="1100") else  --LD REG
         "0000000000000000";

   op_com_cte <= '1' when (opcode="0010") else -- ADDI
               '1' when (opcode="0011") else --SUBI
               '1' when (opcode="1101") else --LD ACC
               '1' when (opcode="1100") else  --LD REG
               '0';

   qual_reg_op <= ( instrucao(10 downto 7)) when (opcode="0100") else -- ADD
                     ( instrucao(10 downto 7)) when (opcode="0101") else --SUB
                     ( instrucao(10 downto 7)) when (opcode="0111") else --OR
                     ( instrucao(10 downto 7)) when (opcode="0110") else  --AND
                     ( instrucao(11 downto 8)) when (opcode="1100") else  --LD
                     ( instrucao(9 downto 6)) when (opcode="1110") else  --MOV
                     "0000";

   nop<= '1' when opcode ="0000" else
          '0';

end architecture;