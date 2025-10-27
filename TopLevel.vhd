library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel is
    port (
        clock : in std_logic;
        reset_b, reset_UC, reset_acc, reset_pmu, reset_mqe, reset_ir, wr_mqe : in std_logic
    );
end entity;

architecture a_TopLevel of TopLevel is

    component reg16bits is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    component BancoReg is
        port( 
        clk_b         : in std_logic; --clock do banco
        rst_b          : in std_logic; --reset do banco
        wr_en         : in std_logic; --write enable do banco
        sel_reg_wr    : in unsigned(3 downto 0); --seleciona o registrados que vai ser escrito
        sel_reg_rd    : in unsigned(3 downto 0); --seleciona o registrador que vai ser lido
        data_wr       : in unsigned(15 downto 0); --dado que vai ser escrito
        data_out_b   : out unsigned(15 downto 0) --dado de saída que foi lido
        );
    end component;

    component ULA is
        port(
            in_A, in_B : in unsigned(15 downto 0);
            Sel0, Sel1 : in std_logic;
            Resultado : out unsigned(15 downto 0);
            Carry, Overflow, Zero, Sinal : out std_logic
        );
    end component;

    component pc_mais_um is
    port(
        CLK, RST, WR_EN, EH_JUMP : in std_logic;
        ENDERECO_JUMP : in unsigned(6 downto 0);
        DATA_OUT : out unsigned(6 downto 0)
    );
    end component;

    component ROM is
    port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
    );
    end component;

    component ROMBRUNA is
    port( 
        clk      : in std_logic;
        endereco : in unsigned(6 downto 0);
        dado     : out unsigned(15 downto 0) 
    );
    end component;

    component reg1bit is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_out : out std_logic
    );
    end component;
    
    component un_controle is
      port( 
        clock : in std_logic;
        instrucao : in unsigned(15 downto 0);

        reset_UC : in std_logic;
        wr_mqe : in std_logic;
        wr_ir : out std_logic;

        eh_jump : out std_logic;
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level

        sel0_ULA : out std_logic;
        sel1_ULA : out std_logic;
        escolhe_accA :out std_logic;
        escolhe_accB :out std_logic;
        wr_en_accA_UC : out std_logic;
        wr_en_accB_UC : out std_logic;

        eh_nop :out std_logic;

        op_mov_p_acc : out std_logic;
        op_ld_acc : out std_logic;
        op_mov_p_reg : out std_logic;
        cte : out unsigned(15 downto 0);
        op_com_cte : out std_logic; --para o mux

        qual_reg_le : out unsigned (3 downto 0);
        qual_reg_escreve : out unsigned (3 downto 0);
        escreve_banco: out std_logic;
        funciona_pc : out std_logic
   );
    end component;

    component pc is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
    );
    end component;

    signal banco_ula, ula_accs, acc0_ula, acc1_ula, accs_ula, dado_ula, dado_escrita_banco, dado_escrita_acc  : unsigned(15 downto 0);
    signal wr_en_accA, wr_en_accB, escolhe_accA, escolhe_accB : std_logic;

    signal wr_ir, escreve_banco: std_logic; 
    signal saida_pmu, endereco_ROM: unsigned(6 downto 0) := (others => '0');
    signal rom_ir, ir_uc, cte : unsigned(15 downto 0);
    signal carry, zero, overflow, sinal, sel0_ULA_out, sel1_ULA_out : std_logic;
    signal qual_reg_le_OUT, qual_reg_escreve_OUT: unsigned (3 downto 0);
    signal eh_jump, eh_nop, funciona_pc, op_com_cte: std_logic; 
    signal op_ld_acc, op_mov_p_reg, op_mov_p_acc: std_logic;
    signal endereco_jump : unsigned(6 downto 0);

begin

    ----------------------parte do banco/accs/ULA

    --MUX entrada do banco
    dado_escrita_banco <= cte when op_mov_p_reg = '0' else --quando é LD em algum reg 
                     accs_ula when op_mov_p_reg = '1' else --quando é MOV acc, reg 
                     (others => '0');

    Banco : BancoReg port map (clk_b => clock, rst_b => reset_b, wr_en => escreve_banco, sel_reg_wr => qual_reg_escreve_OUT, sel_reg_rd => qual_reg_le_OUT, data_wr => dado_escrita_banco, data_out_b => banco_ula);
     
    --MUX entrada dos acumuladores A e B
    dado_escrita_acc <= banco_ula when (op_mov_p_acc = '1' and op_ld_acc = '0') else -- quando é MOV ACC, Rn
                        cte when (op_mov_p_acc = '0' and op_ld_acc = '1') else --quando é LD em algum ACC 
                        ula_accs when (op_mov_p_acc = '0' and op_ld_acc = '0') else --quando é alguma op da ula
                        (others => '0');

    uutaccA : reg16bits port map (clk => clock, rst => reset_acc, wr_en => wr_en_accA , data_in => dado_escrita_acc, data_out => acc0_ula); --acumulador A

    uutaccB : reg16bits port map (clk => clock, rst => reset_acc, wr_en => wr_en_accB, data_in => dado_escrita_acc, data_out => acc1_ula); --acumulador B

    --MUX da saída do banco e da cte na entrada A da ula
    dado_ula <= banco_ula when op_com_cte = '0' else
                cte when op_com_cte = '1' else -- ADDI/SUBI
                (others => '0');
    --MUX da saída dos acc na entrada B da ula
    accs_ula <= acc0_ula when (escolhe_accA = '1') else
                acc1_ula when (escolhe_accB = '1') else
                (others => '0');

    ULA_comp : ULA port map (in_A => dado_ula, in_B => accs_ula, Sel0 => sel0_ULA_out, Sel1 => sel1_ULA_out, Resultado => ula_accs, Carry => carry, Overflow => overflow, Zero => zero, Sinal => sinal);

    --------------------parte do PC/ROM
   
    pmu : pc_mais_um port map (CLK => clock, RST => reset_pmu, WR_EN => funciona_pc, EH_JUMP => eh_jump, ENDERECO_JUMP => endereco_jump, DATA_OUT => saida_pmu);

    --mux entrada do endereço da ROM
    endereco_ROM <= endereco_jump  when eh_jump = '1' else
                    saida_pmu;
    rom0 : ROM port map (clk => clock, endereco => endereco_ROM, dado => rom_ir);

    IR : reg16bits port map (clk => clock, rst => reset_ir, wr_en => wr_ir, data_in => rom_ir, data_out => ir_uc);
                                                                                                                                                   
    UC: un_controle port map ( clock => clock, instrucao => ir_uc, reset_UC => reset_UC, wr_mqe => wr_mqe, 
    eh_jump => eh_jump, endereco_destino => endereco_jump,sel0_ULA => sel0_ULA_out, sel1_ULA => sel1_ULA_out, 
    escolhe_accA => escolhe_accA, escolhe_accB => escolhe_accB , wr_en_accA_UC => wr_en_accA , wr_en_accB_UC =>wr_en_accB,
    eh_nop=> eh_nop, op_mov_p_acc => op_mov_p_acc, op_ld_acc => op_ld_acc, op_mov_p_reg => op_mov_p_reg, 
    cte => cte, op_com_cte => op_com_cte, qual_reg_le => qual_reg_le_OUT, qual_reg_escreve => qual_reg_escreve_OUT, 
    escreve_banco=> escreve_banco,  funciona_pc => funciona_pc, wr_ir => wr_ir);

end a_TopLevel; 