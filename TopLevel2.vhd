library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel2 is
    port (
        clock : in std_logic;
       --elementos dos accs
        reset_acc : in std_logic; --o reset é dos dois e o escreve_accs e os escolhe em conjunto são o wr_en deles
       --elemtentos do PC/MQE
        reset_pmu, reset_mqe, wr_mqe: in std_logic
    );
end entity;

architecture struct of TopLevel2 is

    ---------tipo uma pmu que controla o pc
    component pc_mais_um is
    port(
        CLK, RST, WR_EN : in std_logic;
        DATA_OUT : out unsigned(6 downto 0)
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
    

    component UC is
   port( 
        instrucao : in unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic;
        nop :out std_logic
        
   );
end component;
    signal banco_ula, ula_accs, acc0_ula, acc1_ula, accs_ula, dado_ula, dado_escrita_banco, dado_escrita_acc,acc0_ula_in,acc1_ula_in, banco_ula_IN,acc_p_ula_OUT  : unsigned(15 downto 0);
    signal wr_en_accA, wr_en_accB : std_logic;

    ----------- do PC
    signal estado, wr_pmu,wr_pmu2, JUMP_EN: std_logic; 
    signal saida_pmu, saida_pmu2, vai_p_end_ROM, end_jump, ENDERECO: unsigned(6 downto 0) := (others => '0');
    signal saida_rom : unsigned(15 downto 0);
    signal sel0_ULA_out, sel1_ULA_out, nop: std_logic;
    signal qual_reg_op_OUT: unsigned (3 downto 0);
    signal teve_jump, eh_nop: std_logic;


begin

    --------------------parte do PC/ROM
    maq_estados : reg1bit port map (clk => clock, rst => reset_mqe, wr_en => wr_mqe, data_out => estado);
    --só atualiza o PC no estado 1
    vai_p_end_ROM <= end_jump  when JUMP_EN = '1' else
                    saida_pmu2;
    --pmu : pc_mais_um port map (CLK => clock, RST => reset_pmu, WR_EN => wr_pmu, DATA_OUT => saida_pmu);
    pmu2 : pc_mais_um port map (CLK => clock, RST => reset_pmu, WR_EN => wr_pmu2, DATA_OUT => saida_pmu2);
    wr_pmu2 <= '1' when (estado = '1') else
             '0'; 
    rom0 : ROMBRUNA port map (clk => clock, endereco => vai_p_end_ROM, dado => saida_rom);
    --undidade_controle_antiga: un_controle port map ( instrucao => saida_rom, acc0_ula => acc0_ula_IN, acc1_ula =>acc1_ula_IN, 
     --banco_ula_UC => banco_ula_IN, acc_p_ula =>acc_p_ula_OUT, endereco_destino => ENDERECO, jump_en => JUMP_EN,
     --sel0_ULA => sel0_ULA_out, sel1_ULA => sel1_ULA_out, nop=> nop, qual_reg_op =>qual_reg_op_OUT );

     UC_unid : UC port map(instrucao => saida_rom, endereco_destino => end_jump, jump_en => JUMP_EN, nop => eh_nop);
end struct; 