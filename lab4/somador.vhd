library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity somador is
    port(
        DATA_IN : in unsigned(6 downto 0);
        DATA_OUT : out unsigned(6 downto 0)
    );
end entity;

architecture a_somador of somador is

   signal DATA_S : unsigned(6 downto 0) := (others => '0'); 
   signal DATA_IN_INTERNO : unsigned(6 downto 0);

begin 
    DATA_S <= (DATA_IN + 1);
    DATA_OUT <= DATA_S;
end architecture;