library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BancoReg is
   port( 
        clk_b         : in std_logic; --clock do banco
        rst_b          : in std_logic; --reset do banco
        wr_en         : in std_logic; --write enable do banco
        sel_reg_wr    : in unsigned(3 downto 0); --seleciona o registrados que vai ser escrito
        sel_reg_rd    : in unsigned(3 downto 0); --seleciona o registrador que vai ser lido
        data_wr       : in unsigned(15 downto 0); --dado que vai ser escrito
        data_out_b   : out unsigned(15 downto 0) --dado de saída que foi lido
   );
end entity;

architecture a_BancoReg of BancoReg is

    component reg16bits is
        port( 
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal data_out_tmp, out_r0, out_r1, out_r2, out_r3, out_r4, out_r5, out_r6, out_r7, out_r8, out_r9, out_r10: unsigned(15 downto 0);
    signal wr_en_reg0, wr_en_reg1, wr_en_reg2, wr_en_reg3, wr_en_reg4, wr_en_reg5, wr_en_reg6, wr_en_reg7, wr_en_reg8, wr_en_reg9, wr_en_reg10: std_logic;

    begin
    --Lógica para escrever no registrador desejado
    wr_en_reg0 <= '1' when ((sel_reg_wr = "0000") and (wr_en ='1')) else '0';
    wr_en_reg1 <= '1' when ((sel_reg_wr = "0001") and (wr_en ='1')) else '0';
    wr_en_reg2 <= '1' when ((sel_reg_wr = "0010") and (wr_en ='1')) else '0';
    wr_en_reg3 <= '1' when ((sel_reg_wr = "0011") and (wr_en ='1')) else '0';
    wr_en_reg4 <= '1' when ((sel_reg_wr = "0100") and (wr_en ='1')) else '0';
    wr_en_reg5 <= '1' when ((sel_reg_wr = "0101") and (wr_en ='1')) else '0';
    wr_en_reg6 <= '1' when ((sel_reg_wr = "0110") and (wr_en ='1')) else '0';
    wr_en_reg7 <= '1' when ((sel_reg_wr = "0111") and (wr_en ='1')) else '0';
    wr_en_reg8 <= '1' when ((sel_reg_wr = "1000") and (wr_en ='1')) else '0';
    wr_en_reg9 <= '1' when ((sel_reg_wr = "1001") and (wr_en ='1')) else '0';
    wr_en_reg10 <= '1' when ((sel_reg_wr = "1010") and (wr_en ='1')) else '0';

    --todos os registradores recebem o data_in, o que vai diferenciar é qual vai ser selecionado

    r0: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg0, data_in => data_wr, data_out => out_r0 );
    r1: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg1, data_in => data_wr, data_out => out_r1 );
    r2: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg2, data_in => data_wr, data_out => out_r2 );
    r3: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg3, data_in => data_wr, data_out => out_r3 );
    r4: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg4, data_in => data_wr, data_out => out_r4 );
    r5: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg5, data_in => data_wr, data_out => out_r5 );
    r6: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg6, data_in => data_wr, data_out => out_r6 );
    r7: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg7, data_in => data_wr, data_out => out_r7 );
    r8: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg8, data_in => data_wr, data_out => out_r8 );
    r9: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg9, data_in => data_wr, data_out => out_r9 );
    r10: reg16bits port map(clk => clk_b, rst => rst_b, wr_en => wr_en_reg10, data_in => data_wr, data_out => out_r10 );


    --Lógica para ler do registrador desejado
    data_out_tmp <= out_r0 when (sel_reg_rd = "0000") else
                    out_r1 when (sel_reg_rd = "0001") else
                    out_r2 when (sel_reg_rd = "0010") else
                    out_r3 when (sel_reg_rd = "0011") else
                    out_r4 when (sel_reg_rd = "0100") else
                    out_r5 when (sel_reg_rd = "0101") else
                    out_r6 when (sel_reg_rd = "0110") else
                    out_r7 when (sel_reg_rd = "0111") else
                    out_r8 when (sel_reg_rd = "1000") else
                    out_r9 when (sel_reg_rd = "1001") else
                    out_r10 when (sel_reg_rd = "1010") else
                    "0000000000000000";

    data_out_b <= data_out_tmp;
end architecture;