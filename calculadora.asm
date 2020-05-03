	.data
	.align 0
msg_menu:	.asciiz "Escolha uma opção: \n1-Soma\n2-Subtração\n3-Multiplicação\n4-Divisão\n5-Potência\n6-Raiz Quadrada\n7-Tabuada\n8-IMC\n9-Fatorial\n10-Sequência de Fibonacci\n0-Sair\n"         
msg_num1:	.asciiz "Digite um número inteiro:\n"
msg_num2:	.asciiz "Digite outro número inteiro:\n"
msg_result:	.asciiz "O resultado é: "
msg_nn:		.asciiz "\n\n"

	.text
	.globl main 

main:
	j menu  
menu:
	li $v0, 4
	la $a0, msg_menu
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
	beq $v0, 9, fatorial
	beq $v0, 10, raiz
	beq $v0, 0, sair

	j menu
soma:
	jal ler_num1        
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

        add $a0, $s0, $s1

	jal print_result

	j menu

subtracao:
	jal ler_num1
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

	sub $a0, $s0, $s1

	jal print_result

	j menu

multiplicacao:
	jal ler_num1
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

	mult $s0, $s1
	mflo $a0

	jal print_result

	j menu

divisao:
        jal ler_num1
        move $s0, $v0

	jal ler_num2
	move $s1, $v0

	div $s0, $s1
	mflo $a0

	jal print_result

	j menu

potencia:
	jal ler_num1
        
	j menu

raiz:
	jal ler_num1

	j menu

tabuada:
	jal ler_num1
 
	j menu

imc:
	jal ler_num1
 
	j menu

fatorial:
	jal ler_num1

	move $t0, $v0
	li $a0, 1   # Resultado do fatorial

	# for(t0 = a0, t0 != 0, t0--)
	loop_t0:
		mult $a0, $t0
		mflo $a0

		subi $t0, $t0, 1

		beqz $t0, loop_t0_fim
		j loop_t0
	loop_t0_fim:

	jal print_result

	j menu

fibonacci:
	jal ler_num1

	j menu

sair:
	li $v0, 10
	syscall

# Imprime número pelo argumento $a0      
print_result:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)

	# Imprime string msg_result
	li $v0, 4
        la $a0, msg_result
        syscall
        
        # Imprime int que veio de argumento
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

# Le um número e retorna para o $v0
ler_num1:
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num1
        syscall
 
        li $v0, 5
        syscall

	lw $a0, 0($sp)
	lw $ra, 4($sp)	
	addi $sp, $sp, 8
	
	jr $ra

# Le um número e retorna para o $v0
ler_num2:
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num2
        syscall
 
        li $v0, 5
        syscall

	lw $a0, 0($sp)
	lw $ra, 4($sp)	
	addi $sp, $sp, 8
	
	jr $ra