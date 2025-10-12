library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc is
    port(
        CLK, RST, WR_EN : in std_logic;
        DATA_OUT : out unsigned(6 downto 0)
    );
end entity;

architecture a_proto_uc of proto_uc is

   component pc is
   port( 
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
   );
   end component;

   signal DATA_S, DATA_IN : unsigned(6 downto 0);

begin 
    DATA_IN <= (DATA_S + 1);
    PC : pc port map(clk => CLK, rst => RST, wr_en => WR_EN, data_in => DATA_IN, data_out => DATA_S);

    DATA_OUT <= DATA_S;
end architecture;