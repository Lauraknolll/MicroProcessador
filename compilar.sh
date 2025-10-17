#!/bin/bash

# Define a lista de arquivos VHDL a serem compilados
ARQUIVOS_VHDL="PC/pc_mais_um.vhd UC/UC.vhd PC/pc.vhd ROM/ROMBRUNA.vhd"

# --- 1. Limpeza ---
echo "--- Removendo o diretório de trabalho work-obj93 para limpeza ---"
# O 'rm -rf' remove recursivamente e força (sem pedir confirmação)
rm -rf work-obj93

# Verifica se a remoção foi bem-sucedida (ou se o diretório não existia, o que é OK)
if [ $? -eq 0 ]; then
    echo "Diretório work-obj93 removido (ou não existia)."
else
    echo "Aviso: Não foi possível remover work-obj93. Continuando..."
fi

# --- 2. Compilação GHDL ---
echo "--- Compilando os arquivos VHDL ---"

# O comando 'ghdl -a' pode receber múltiplos arquivos como argumentos.
# Todos serão compilados na biblioteca 'work' (padrão)
ghdl -a $ARQUIVOS_VHDL

# Verifica o status de saída do último comando (ghdl -a)
if [ $? -eq 0 ]; then
    echo "Sucesso: Todos os arquivos VHDL foram compilados corretamente na biblioteca work."
else
    echo "ERRO: Ocorreram erros durante a compilação dos arquivos VHDL."
    exit 1
fi
