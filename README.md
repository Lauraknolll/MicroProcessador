Progresso até agora do LAB 7:

- O registrador 10 é o endereço de memória

- O acumulador B é o conteúdo armazenado

- É necessário fazer um LD no reg10 e no accB antes

- SW guarda na memória 

- LW carrega no accB o conteúdo do endereço pedido

- Na ROM.vhd:
    - Incialamente eu aramzenei 2 no endereço 7, 6 no 16 e 26 no 10.
    - Depois li na ordem: endereço 16 (valor 6), endereço 7 valor (2) e endereço 10 valor (26).
    - Nessa sequência, fui guardando os valores lidos nos reg0, reg1 e reg2.
    - Armazenei 56 na posição 10 da memória, li e guardei no reg3.
    - Armazenei 30 na posição 10 da memória, li e guardei no reg4.
 
        
Sugestões:

- Seria interessante fazer um teste com loop, testando valores (de endereço) na sequência...
