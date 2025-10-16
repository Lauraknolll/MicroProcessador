library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_mais_um is
    port(
        CLK, RST, WR_EN, EH_JUMP : in std_logic;
        ENDERECO_JUMP : in unsigned(6 downto 0);
        DATA_OUT : out unsigned(6 downto 0)
    );
end entity;

architecture a_pc_mais_um of pc_mais_um is

   component pc is
   port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
   );
   end component;

   signal DATA_S : unsigned(6 downto 0) := (others => '0'); 
   signal DATA_IN : unsigned(6 downto 0);

begin 
    --mux dizendo se quem quero guardar é o endereço do jump ou o próximo na sequência
    DATA_IN <= ENDERECO_JUMP when EH_JUMP = '1' else
        (DATA_S + 1);
    PC0 : pc port map(clk => CLK, rst => RST, wr_en => WR_EN, data_in => DATA_IN, data_out => DATA_S);

    DATA_OUT <= DATA_S;
end architecture;