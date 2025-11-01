library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg4bits is
   port( 
      clk      : in std_logic;
      rst      : in std_logic;
      wr_en    : in std_logic;
      c_in, v_in, n_in, z_in  : in std_logic;
      c_out, v_out, n_out, z_out : out std_logic
   );
end entity;

architecture a_reg4bits of reg4bits is
   signal registro1, registro2, registro3, registro4: std_logic;
begin
   process(clk,rst,wr_en)  -- acionado se houver mudança em clk, rst ou wr_en
   begin                
      if rst='1' then
        registro1 <= '0';
        registro2 <= '0';
        registro3 <= '0';
        registro4 <= '0';
      elsif wr_en='1' then
            if rising_edge(clk) then
                registro1 <= c_in;
                registro2 <= v_in;
                registro3 <= n_in;
                registro4 <= z_in;
            end if;
      end if;
   end process;
   
   c_out <= registro1;
   v_out <= registro2;
   n_out <= registro3;
   z_out <= registro4; 
end architecture;