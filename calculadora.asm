          .data
          .align 0
message1: .asciiz "Escolha uma opção: \n1-Soma\n2-Subtração\n3-Multiplicação\n4-Divisão\n5-Potência\n6-Raiz Quadrada\n7-Tabuada\n8-IMC\n9-Fatorial\n10-Sequência de Fibonacci\n0-Sair\n"         
message2: .asciiz "Digite um número inteiro:\n"
message3: .asciiz "Digite outro número inteiro:\n"
message4: .asciiz "O resultado é: "
message5: .asciiz "\n\n"

          .text
          .globl main 

main:
         j menu  
menu:
         li $v0, 4
         la $a0, message1
         syscall
         
         li $v0, 5
         syscall
         
         beq $v0, 1, soma
         beq $v0, 2, subtracao
         beq $v0, 3, multiplicacao
         beq $v0, 4, divisao
         beq $v0, 5, potencia
         beq $v0, 6, raiz
         beq $v0, 7, multiplicacao
         beq $v0, 8, divisao
         beq $v0, 9, potencia
         beq $v0, 10, raiz
         beq $v0, 0, sair

	 j menu
soma:
         li $v0, 4
         la $a0, message2
         syscall
         
         li $v0, 5
         syscall
         
         move $t0, $v0
         
         li $v0, 4
         la $a0, message3
         syscall
         
         li $v0, 5
         syscall
         
         move $t1, $v0
         
         add $t2, $t0, $t1
         
         li $v0, 4
         la $a0, message4
         syscall
         
         li $v0, 1
         move $a0, $t2
         syscall
         
         li $v0, 4
         la $a0, message5
         syscall
         
         j menu
subtracao:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
multiplicacao:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
divisao:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
potencia:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
raiz:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
tabuada:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
imc:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
fatorial:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
fibonacci:
         li $v0, 4
         la $a0, message2
         syscall
         
         j menu
sair:
         li $v0, 10
         syscall
