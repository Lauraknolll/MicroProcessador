Para o Lab 4

Necessidades:

Fazer o somador contar do ultimo endereço do pc, atualmente ele começa em zero e vai até o infinito e além
Seria bom também colocar a máquina de estados dentro da UC

Para entrega:

pc_mais_um: precisa atualizar para ele pegar os desvios do jump e não ter o comportamento atual: soma 1 do zero que foi o primeiro endereço. Ele tem que pegar o último enedereço do PC e somar 1, mesmo tendo jump.

ROMBRUNA.vhd : é o arquivos de isntruções do PC, como conteúdo de cada posição, temos uma instrução.

TopLevel2.vhd : é o top level que testa apenas a ROM, PC_mais_um, UC e a maquina de estados

TopLevel_tb2.vhd: apenas testa os componentes.

UC: unidade de controle que apenas faz a deocdificação de jump e nop (fiquei na duivda como implementar a instrução nop, se precisa desativar o clks, não tem nenhuma configuração que dependa dela além da flag)

A UC recebe como entrada a instrução (conteúdo da instrução acessada pela ROM) e devolve o endereço do jump (quando não houver jump é 0000000) e as flagas indicativas.

Restante:

Somador.vhd: foi o principio de algo diferente (fazer o módulo de somar 1 separado), mas não foi para frente

ROM.vhd: supostamente como original (que a Laura fez)

TopLevel.vhd: supostamente original como estava.
- acabei colocando a unidade de controle antiga comentada
- coloquei mais um pc_mais_um que pausava (pode estar comentado)
- 
TopLevel_tb.vhd: supostamente original como estava.

TopLevel_tb1: faz as operações de antes, ULA, BANCO... (fazendo todas as operações)

un_controle.vhd: é a unidade de controle antiga, na qual eu pegava "instruções globais" que eu recebia como entrada com compenente TopLevel, eu estava usando a ROM, como se fosse a RAM, com acesso esporático.

un_controle_tb.vhd: eu escrevia as intruções no process.

Bônus:

- no Sheets tem a panilha das instruções
