library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity BancoReg is
   port( clk_b         : in std_logic;
         rst_b          : in std_logic;
         wr_en         : in std_logic;
         sel_reg_wr    : in unsigned(3 downto 0);
         sel_reg_rd    : in unsigned(3 downto 0);
         acc           : in std_logic; --se for 0 será o acumulador acc0 e se for 1 será o acc1
         data_wr       : in unsigned(15 downto 0);
         data_out_r1   : out unsigned(15 downto 0)
   );
end entity;
architecture a_BancoReg of BancoReg is

    component reg16bits is
        port( clk      : in std_logic;
                rst      : in std_logic;
                wr_en    : in std_logic;
                data_in  : in unsigned(15 downto 0);
                data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_out_tmp,out_r0, out_r1, out_r2, out_r3: unsigned(15 downto 0);
    signal wr_en_reg0, wr_en_reg1, wr_en_reg2, wr_en_reg3: std_logic;

    begin
    --Lógica para escrever no registrador desejado
    wr_en_reg0 <= '1' when ((sel_reg_wr = "0000") and (wr_en ='1')) else '0';
    wr_en_reg1 <= '1' when ((sel_reg_wr = "0001") and (wr_en ='1')) else '0';
    wr_en_reg2 <= '1' when ((sel_reg_wr = "0010") and (wr_en ='1')) else '0';
    wr_en_reg3 <= '1' when ((sel_reg_wr = "0011") and (wr_en ='1')) else '0';

    --TODOS O REGISTRADORES RECEBEM O DATA_IN, O QUE VAI DIFERENCIAR É QUE 1 vai ser selecionado

    --Lógica para ler do registrador esperado
    data_out_tmp <= out_r0 when (sel_reg_rd = "0000") else
                    out_r1 when (sel_reg_rd = "0001") else
                    out_r2 when (sel_reg_rd = "0010") else
                    out_r3 when (sel_reg_rd = "0011") else
                    "0000000000000000";

    r0: reg16bits port map(clk_b, rst_b, wr_en_reg0, data_wr, out_r0 );
    r1: reg16bits port map(clk_b, rst_b, wr_en_reg1, data_wr, out_r1 );
    r2: reg16bits port map(clk_b, rst_b, wr_en_reg2, data_wr, out_r2 );
    r3: reg16bits port map(clk_b, rst_b, wr_en_reg3, data_wr, out_r3 );

    data_out_r1 <= data_out_tmp;
end architecture;