library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
   port( 
      clock : in std_logic;
      instrucao : in unsigned(15 downto 0);

      reset_UC : in std_logic;
      wr_mqe : in std_logic;
      
      carry, overflow, negativo, zero : in std_logic;

      wr_ir : out std_logic;
      wr_en_flags : out std_logic;

      eh_jump : out std_logic;
      endereco_destino: out unsigned(6 downto 0); --esta assim no top level

      eh_comparacao : out std_logic;
      eh_branch : out std_logic;
      endereco_branch_relativo: out unsigned(6 downto 0); 

      sel0_ULA : out std_logic;
      sel1_ULA : out std_logic;
      escolhe_accA :out std_logic;
      escolhe_accB :out std_logic;
      wr_en_accA_UC : out std_logic;
      wr_en_accB_UC : out std_logic;
      wr_en_RAM : out std_logic;

      eh_nop : out std_logic;
      eh_excecao : out std_logic;

      op_load : out std_logic;
      op_mov_p_acc : out std_logic;
      op_ld_acc : out std_logic;
      op_mov_p_reg : out std_logic;
      cte : out unsigned(15 downto 0);
      op_com_cte : out std_logic; 

      qual_reg_le : out unsigned (3 downto 0);
      qual_reg_escreve : out unsigned (3 downto 0);
      escreve_banco: out std_logic;
      wr_en_pc : out std_logic
   );
end entity;

architecture a_un_controle of un_controle is

   signal opcode: unsigned(3 downto 0);
   signal  accs_ula, dado_ula, dado_escrita_banco, dado_escrita_acc : unsigned(15 downto 0);
   signal escolhe_acc_A :  std_logic;
   signal  escolhe_acc_B :  std_logic;
   signal  escreve_acc, define_maior_menor :  std_logic;
   signal estado : unsigned (2 downto 0);

   component maq_estados is
      port( 
         clk,rst: in std_logic;
         estado: out unsigned(2 downto 0)
   );
   end component;

begin                                                     
   maq_estados2 : maq_estados port map (clk => clock, rst => reset_UC, estado => estado);
    
   --só atualiza o pc no estado 3 depois que já usou (mas quando já tem a informação se é jump, branch ou não)
   wr_en_pc <= '1' when (estado = "011") else
                  '0'; 

   -- coloquei o opcode nos 4 bits MSB
   opcode <= instrucao(15 downto 12);

   --IR (eh pra entrar nele quando está no estado 2)
   wr_ir <= '1' when (estado = "010") else
            '0'; 
   
   --excecao
   eh_excecao <= '1' when opcode = "0000" else
                 '0';
   
   --operação de jump
   eh_jump <=  '1' when opcode="1111" else
               '0';
   endereco_destino <= instrucao(6 downto 0) when opcode = "1111" else
                        "0000000";

   --operação branch
   endereco_branch_relativo<= instrucao(6 downto 0) when opcode = "1010" else -- BGE
                              instrucao(6 downto 0) when opcode = "1011" else -- BHI
                              "0000000";

   eh_branch <= '1' when (((opcode = "1010" and negativo = overflow) OR (opcode = "1011" and carry = '0' and zero = '0') )) else
                '0';
   eh_comparacao <= '1' when (opcode ="1001" AND instrucao(6 downto 0) = "0000000") else
                    '0';

   wr_en_flags <= '1' when (opcode ="1001" AND (instrucao(6 downto 0) = "0000000") and estado = "011") else -- COMP
                  '1' when(opcode="0100") else --ADD
                  '1' when(opcode="0101") else --SUB
                  '1' when(opcode="0111") else --OR
                  '1' when(opcode="0110") else --AND
                  '1' when(opcode="0010") else --ADDI
                  '1' when(opcode="0011") else --SUBI
                  '1' when(opcode="1101") else --LD ACC
                  '1' when(opcode="1110") else --MOV 
                  '1' when(opcode="1100") else --LD REG
                  '0';
   -- escrita na RAM
   wr_en_RAM <= '1' when (opcode = "1000") else -- SW salva na memória
                   '0';

   --leitura na RAM
   op_load <= '1' when (opcode = "0001") else-- LW
                '0';


   --operação de nop
   eh_nop<= '1' when (opcode ="1001" AND instrucao(11 downto 0) = "011100110011") else
            '0';

   -- o bit 11 define qual acc será usado, 0 para o A e 1 para o B
   escolhe_acc_A <= not(instrucao(11)); --and (not(opcode = "1101"))and (not(opcode = "1100")) -- não é MOV nem LD
   escolhe_acc_B <= '1' when ((opcode = "0001" ) or (opcode = "1000")) else -- ACC B fixo para instrução SW ou LW
                     instrucao(11); 

                                                                                   
   sel0_ULA <= '0' when (opcode = "0100" OR opcode = "0010" OR opcode = "0110" ) else --ADD OU ADDI ou AND
                  '1';
                                                                                                       -- comp
   sel1_ULA <= '0' when (opcode = "0101" OR opcode = "0011" OR opcode = "0010" OR opcode = "0100" OR (opcode = "1001" and instrucao(6 downto 0) = "0000000")) else --SUB OU SUBI ou ADD ou ADDI ou COMP
                  '1';


   op_com_cte <= '1' when (opcode="0010") else -- ADDI
                 '1' when (opcode="0011") else --SUBI
                 '1' when (opcode="1101") else --LD ACC
                 '1' when (opcode="1100") else  --LD REG
                 '0';

   cte <= ("00000000" & instrucao(7 downto 0)) when (opcode="0010" and instrucao(7)='0') else -- ADDI
          ("11111111" & instrucao(7 downto 0)) when (opcode="0010" and instrucao(7)='1') else -- ADDI
          ("00000000" & instrucao(7 downto 0)) when (opcode="0011" and instrucao(7)='0') else --SUBI
          ("11111111" & instrucao(7 downto 0)) when (opcode="0011" and instrucao(7)='1') else --SUBI
          ("00000000" & instrucao(7 downto 0)) when (opcode="1101" and instrucao(7)='0') else --LD ACC
          ("11111111" & instrucao(7 downto 0)) when (opcode="1101" and instrucao(7)='1') else --LD ACC
          ("00000000" & instrucao(7 downto 0)) when (opcode="1100" and instrucao(7)='0') else  --LD REG
          ("11111111" & instrucao(7 downto 0)) when (opcode="1100" and instrucao(7)='1') else  --LD REG
           "0000000000000000";

   qual_reg_le <= ( instrucao(10 downto 7)) when (opcode="0100") else -- ADD
                  ( instrucao(10 downto 7)) when (opcode="0101") else --SUB
                  ( instrucao(10 downto 7)) when (opcode="0111") else --OR
                  ( instrucao(10 downto 7)) when (opcode="0110") else  --AND
                  --( instrucao(11 downto 8)) when (opcode="1100") else  --LD REG
                  ( instrucao(10 downto 7)) when (opcode="1110") else  --MOV
                  ( instrucao(10 downto 7)) when (opcode="1001" and instrucao(6 downto 0) = "0000000") else  -- COMP
                  ( "1010") when ((opcode="1000") or (opcode="0001")) else  -- para SW ou LW sempre será o reg 10
                  "0000";

   escreve_acc <= '1' when(opcode="0100") else --ADD
                  '1' when(opcode="0101") else --SUB
                  '1' when(opcode="0111") else --OR
                  '1' when(opcode="0110") else --AND
                  '1' when(opcode="0010") else --ADDI
                  '1' when(opcode="0011") else --SUBI
                  '1' when(opcode="1101") else --LD ACC
                  '1' when((opcode="1110") and (instrucao(6)= '1')) else --MOV PARA ACC
                  '0';

   --escreve no estado 4 que é onde ocorre o execute
   wr_en_accA_UC <=  '1' when ((escolhe_acc_A = '1') and (escreve_acc ='1') and (estado = "100")) else
                     '0';                                                                                      -- LW
   wr_en_accB_UC <=  '1' when (((escolhe_acc_B ='1') and (escreve_acc = '1')  and (estado = "100")) OR (opcode = "0001")) else
                     '0';

   -- Se for 1 o ACC é destino e se for 0 o REG é o destino
   op_mov_p_acc <= instrucao(6) when (opcode = "1110") else
                  '0'; 
   op_mov_p_reg <= not(instrucao(6)) when (opcode = "1110") else
                  '0'; 
                                                      -- LW
   op_ld_acc <= '1' when (opcode = "1101" or opcode = "0001") else
                '0';

   --quando é LD em um registrador ou quando é MOV pra um registrador
   qual_reg_escreve <= ( instrucao(11 downto 8)) when (opcode="1100") else  --LD REG
                       (instrucao(10 downto 7)) when ((opcode="1110") and (instrucao(6)='0')) else  --MOV REG
                        "0000";     
   --só escreve no execute que é o estado 4                                 
   escreve_banco <= '1' when ((opcode="1100") and (estado = "100")) else --LD REG
                    '1' when ((opcode="1110") and (instrucao(6)='0') and (estado = "100")) else  -- MOV REG
                    '0';

   escolhe_accA <= escolhe_acc_A;
   escolhe_accB <= escolhe_acc_B;

end architecture;