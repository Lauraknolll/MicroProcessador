entity BancoReg is
   port( clk_b         : in std_logic;
         rst_b          : in std_logic;
         wr_en         : in std_logic;
         sel_reg_wr    : in unsigned(3 downto 0);
         sel_reg_rd    : in unsigned(3 downto 0);
         acc           : in std_logic; --se for 0 será o acumulador acc0 e se for 1 será o acc1
         data_wr       : in unsigned(15 downto 0);
         data_out_r1   : out unsigned(15 downto 0);
         data_out_acc  : out unsigned(15 downto 0)

   );
end entity;

--apenas o sinais de entradas ficam no process
--os sinais de saída apareceram logo no sinal que foi mapeado como saida do componente