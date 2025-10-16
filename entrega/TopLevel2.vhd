library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TopLevel2 is
    port (
        clock : in std_logic;
        reset_pmu, reset_uc, wr_uc: in std_logic
    );
end entity;

architecture struct of TopLevel2 is

    ---------tipo uma pmu que controla o pc
    component pc_mais_um is
    port(
        CLK, RST, WR_EN, EH_JUMP : in std_logic;
        ENDERECO_JUMP : in unsigned(6 downto 0);
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

    component UC is
    port( 
        clock, reset, wr : in std_logic;
        funciona_pc : out std_logic;
        ---
        instrucao : in unsigned(15 downto 0);
        endereco_destino: out unsigned(6 downto 0); --esta assim no top level
        jump_en : out std_logic;
        nop :out std_logic  
    );
    end component;

    signal estado, funciona_pc: std_logic; 
    signal saida_pmu, end_jump, ENDERECO: unsigned(6 downto 0) := (others => '0');
    signal saida_rom : unsigned(15 downto 0);
    signal eh_jump, eh_nop: std_logic;


begin
    pmu : pc_mais_um port map (CLK => clock, RST => reset_pmu, WR_EN => funciona_pc, EH_JUMP => eh_jump, ENDERECO_JUMP => end_jump, DATA_OUT => saida_pmu);

    rom0 : ROMBRUNA port map (clk => clock, endereco => saida_pmu, dado => saida_rom);

    UC_unid : UC port map(clock => clock, reset => reset_uc, wr => wr_uc, funciona_pc => funciona_pc, instrucao => saida_rom, endereco_destino => end_jump, jump_en => eh_jump, nop => eh_nop);
end struct; 