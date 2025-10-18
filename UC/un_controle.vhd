library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity un_controle is
   port( 
        instrucao : in unsigned(15 downto 0);
        jump_en : out std_logic;
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        sel0_ULA : out std_logic;
        sel1_ULA : out std_logic;
        wr_en_accA_UC : out std_logic;
        wr_en_accB_UC : out std_logic;
        nop :out std_logic;
        op_mov_p_acc <= out std_logic;
        op_ld_acc <= out std_logic;
        op_mov_p_reg <= out std_logic;
        cte : out unsigned(15 downto 0);
        op_com_cte : out std_logic; --para o mux
        qual_reg_op : out unsigned (3 downto 0);
        qual_reg_escreve : out unsigned (3 downto 0);
        escreve_banco: out std_logic;
        funciona_pc : out std_logic;
   );
end entity;

architecture a_un_controle of un_controle is
   signal opcode: unsigned(3 downto 0);
   signal  accs_ula,cte, dado_ula, dado_escrita_banco, dado_escrita_acc : unsigned(15 downto 0);
   signal escolhe_accA :  std_logic;
   signal  escolhe_accB :  std_logic;
   -- signal  op_com_cte :  std_logic;
   component maq_estados is
      port( clk,rst: in std_logic;
         estado: out unsigned(1 downto 0)
   );
   end component;

   signal opcode: unsigned(3 downto 0);
   signal estado : unsigned (1 downto 0);
   si

begin
   maq_estados : maq_estados port map (clk => clock, rst => reset, wr_en => wr, data_out => estado);
    
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
      -- O bit 11 define qual acc será usado, 0 para o A e 1 para o B
      escolhe_accA <= not(instrucao(11)); --and (not(opcode = "1101"))and (not(opcode = "1100")) -- não é MOV nem LD
      escolhe_accB <= instrucao(11); 
      sel0_ULA <='0' when (opcode = "0100" OR opcode = "0010" or opcode = "0110") else --ADD OU ADDI ou AND
                  '1';
      sel1_ULA <='0' when (opcode = "0101" OR opcode = "0011" or opcode = "0010" or opcode = "0100") else --SUB OU SUBI ou ADD ou ADDi
                  '1';
      cte <= ("00000000" & instrucao(7 downto 0)) when (opcode="0010") else -- ADDI
             ("00000000" & instrucao(7 downto 0)) when (opcode="0011") else --SUBI
             ("00000000" & instrucao(7 downto 0)) when (opcode="1101") else --LD ACC
             ("00000000" & instrucao(7 downto 0)) when (opcode="1100") else  --LD REG
              "0000000000000000";
      op_com_cte <= '1' when (opcode="0010") else -- ADDI
                   '1' when (opcode="0011") else --SUBI
                   '1' when (opcode="1101") else --LD ACC
                   '1' when (opcode="1100") else  --LD REG
                   '0';
      qual_reg_le <= ( instrucao(10 downto 7)) when (opcode="0100") else -- ADD
                     ( instrucao(10 downto 7)) when (opcode="0101") else --SUB
                     ( instrucao(10 downto 7)) when (opcode="0111") else --OR
                     ( instrucao(10 downto 7)) when (opcode="0110") else  --AND
                     --( instrucao(11 downto 8)) when (opcode="1100") else  --LD REG
                     ( instrucao(10 downto 7)) when (opcode="1110") else  --MOV
                     "0000";
      escreve_acc <= '1' when(opcode="0100") else --ADD
                     '1' when(opcode="0101") else --SUB
                     '1' when(opcode="0111") else -- OR
                     '1' when(opcode="0110") else -- AND
                     '1' when(opcode="0010") else --ADDI
                     '1' when(opcode="0011") else --SUBI
                     '1' when(opcode="1101") else --LD ACC
                     '1' when(opcode="1110" and instrucao(6)) else --MOV PARA ACC
                     '0';

    wr_en_accA_UC <=  (escolhe_accA and escreve_acc);
    wr_en_accB_UC <=  (escolhe_accB and escreve_acc);

    nop<= '1' when opcode ="1000" else
            '0';
   -- Se for 1 o ACC é destino e se for 0 o REG é o destino
   op_mov_p_acc <= instrucao(6) when (opcode = "1110") else
                   '0'; 

   op_ld_acc <= '1' when (opcode = "1101") else
                 '0';
            -- aqui o zero indica que vai para o reg
   op_mov_p_reg <= not(instrucao(6)) when (opcode = "1110") else
                   '0'; 
   qual_reg_escreve <= ( instrucao(11 downto 8)) when (opcode="1100") else  --LD REG
                       (instrucao(10 downto 7)) when ((opcode="1110") and (instrucao(6)='0') else  --MOV REG
                        "0000";                                       --indica que vai pra o REG
   escreve_banco <= '1' when (opcode="1100") else --LD REG
                     '1' when ((opcode="1110") and (instrucao(6)='0') else  -- MOV REG
                     '0';
end architecture;