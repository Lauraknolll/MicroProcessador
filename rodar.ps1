# compilar.ps1
# Script PowerShell para compilar e rodar o projeto GHDL

Write-Host "Iniciando compilação com GHDL..."

# Análise (ghdl -a)
ghdl -a BANCO/reg16bits.vhd 
ghdl -a BANCO/BancoReg.vhd 
ghdl -a UC/reg1bit.vhd 
ghdl -a ULA/ULA.vhd 
ghdl -a PC/pc.vhd
ghdl -a PC/pc_mais_um.vhd
ghdl -a UC/maq_estados.vhd
ghdl -a UC/UC.vhd
ghdl -a ROM/ROMBRUNA.vhd
ghdl -a TopLevel.vhd
ghdl -a processador_tb.vhd

# Elaboração e execução (ghdl -r)
Write-Host "Executando simulação..."
ghdl -r processador_tb --wave=processador_tb.ghw

Write-Host "Simulação concluída! Arquivo de onda gerado: processador_tb.ghw"

Write-Host "Abrindo a forma de onda..."
gtkwave EntregaLab5.gtkw