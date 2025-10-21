# compilar.ps1
# Script PowerShell para compilar e rodar o projeto GHDL

Write-Host "Iniciando compilação com GHDL..."

# Análise (ghdl -a)
ghdl -a PC/pc.vhd
ghdl -a PC/pc_mais_um.vhd
ghdl -a UC/maq_estados.vhd
ghdl -a UC/un_controle.vhd
ghdl -a ROM/ROMBRUNA.vhd
ghdl -a TopLevel.vhd
ghdl -a TopLevel_tb.vhd

# Elaboração e execução (ghdl -r)
Write-Host "Executando simulação..."
ghdl -r TopLevel_tb --wave=TopLevel_tb.ghw

#Write-Host "Simulação concluída! Arquivo de onda gerado: TopLevel_tb.ghw"

Write-Host "Executando simulação..."
gtkwave TopLevel_tb.ghw
