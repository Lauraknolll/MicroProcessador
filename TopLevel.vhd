library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel is
    port (
        clock : in std_logic;
        --elementos do banco
        dado_ext_escrita_banco : in unsigned(15 downto 0);
        reset_b, escreve_banco : in std_logic; --escreve banco é o write enable do banco
        qual_reg_escreve, qual_reg_le : in unsigned(3 downto 0); 

        --elementos dos accs
        reset_acc, escreve_acc, escolhe_accA, escolhe_accB : in std_logic; --o reset é dos dois e o escreve_accs e os escolhe em conjunto são o wr_en deles
        dado_ext_escrita_acc : in unsigned(15 downto 0);

        --operação com cte (ADDI/SUBI), operação MOV Rn, ACC vai pro registrador, operação MOV ACC, Rn vai pro acumulador, operação de LD nos acumuladores
        op_com_cte, op_mov_p_reg, op_mov_p_acc, op_ld_acc : in std_logic;  
        cte : in unsigned(15 downto 0); --a cte que vem da instrução

        --elemento da ULA
        sel0, sel1 : in std_logic; --operações da ula
        carry, overflow, zero, sinal : out std_logic;

        --elemtentos do PC/MQE
        reset_pmu, reset_mqe, wr_mqe: in std_logic
    );
end entity;

architecture struct of TopLevel is

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

    ---------tipo uma pmu que controla o pc
    component pc_mais_um is
    port(
        CLK, RST, WR_EN : in std_logic;
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

    component reg1bit is
    port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_out : out std_logic
    );
    end component;


    signal banco_ula, ula_accs, acc0_ula, acc1_ula, accs_ula, dado_ula, dado_escrita_banco, dado_escrita_acc : unsigned(15 downto 0);
    signal wr_en_accA, wr_en_accB : std_logic;

    ----------- do PC
    signal estado, wr_pmu: std_logic; 
    signal saida_pmu : unsigned(6 downto 0) := (others => '0');
    signal saida_rom : unsigned(15 downto 0);

begin

    ----------------------parte do banco/accs/ULA

    --MUX entrada do banco
    dado_escrita_banco <= dado_ext_escrita_banco when op_mov_p_reg = '0' else --quando é LD em algum reg
                    accs_ula when op_mov_p_reg = '1' else --quando é MOV acc, reg
                    (others => '0');

    uut0 : BancoReg port map (clk_b => clock, rst_b => reset_b, wr_en => escreve_banco, sel_reg_wr => qual_reg_escreve, sel_reg_rd => qual_reg_le, data_wr => dado_escrita_banco, data_out_b => banco_ula);

    --MUX entrada dos acumuladores A e B
    dado_escrita_acc <= banco_ula when (op_mov_p_acc = '1' and op_ld_acc = '0') else -- quando é MOV ACC, Rn
                    dado_ext_escrita_acc when (op_mov_p_acc = '0' and op_ld_acc = '1') else --quando é LD em algum ACC
                    ula_accs when (op_mov_p_acc = '0' and op_ld_acc = '0') else --quando é alguma op da ula
                    (others => '0');

    --pra só escrever quando for instrução de escrever no acc
    wr_en_accA <=  (escolhe_accA and escreve_acc);
    wr_en_accB <=  (escolhe_accB and escreve_acc);   

    uutA : reg16bits port map (clk => clock, rst => reset_acc, wr_en => wr_en_accA , data_in => dado_escrita_acc, data_out => acc0_ula); --acumulador A

    uutB : reg16bits port map (clk => clock, rst => reset_acc, wr_en => wr_en_accB, data_in => dado_escrita_acc, data_out => acc1_ula); --acumulador B

    --MUX da saída do banco e da cte na entrada A da ula
    dado_ula <= banco_ula when op_com_cte = '0' else
                cte when op_com_cte = '1' else -- ADDI/SUBI
                (others => '0');
    --MUX da saída dos acc na entrada B da ula
    accs_ula <= acc0_ula when (escolhe_accA = '1') else
                acc1_ula when (escolhe_accB = '1') else
                (others => '0');

    uut1 : ULA port map (in_A => dado_ula, in_B => accs_ula, Sel0 => sel0, Sel1 => sel1, Resultado => ula_accs, Carry => carry, Overflow => overflow, Zero => zero, Sinal => sinal);

    --------------------parte do PC/ROM
    maq_estados : reg1bit port map (clk => clock, rst => reset_mqe, wr_en => wr_mqe, data_out => estado);
    --só atualiza o PC no estado 1
    wr_pmu <= '1' when estado = '1' else
             '0';
    pmu : pc_mais_um port map (CLK => clock, RST => reset_pmu, WR_EN => wr_pmu, DATA_OUT => saida_pmu);
    rom0 : ROM port map (clk => clock, endereco => saida_pmu, dado => saida_rom);

end struct; 