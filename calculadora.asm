.data
	.align 0
msg_menu:	.asciiz "Escolha uma opção: \n1-Soma\n2-Subtração\n3-Multiplicação\n4-Divisão\n5-Potência\n6-Raiz Quadrada\n7-Tabuada\n8-IMC\n9-Fatorial\n10-Sequência de Fibonacci\n0-Sair\n"         
msg_num1:	.asciiz "Digite um número inteiro:\n"
msg_num2:	.asciiz "Digite outro número inteiro:\n"
msg_float:       .asciiz "Digite um número real:\n"
msg_massa:       .asciiz "Digite a massa(Kg): \n"
msg_alt:       .asciiz "Digite a altura(m): \n"
msg_icmc:       .asciiz "O IMC é igual a: "
msg_n:		.asciiz "\n"
msg_nn:		.asciiz "\n\n"
msg_sym_eq:       .asciiz " = "
msg_sym_plus:       .asciiz " + "
msg_sym3:       .asciiz " - "
msg_sym4:       .asciiz " x "
msg_sym5:       .asciiz " / "
msg_sym6:       .asciiz "!"
msg_sym7:       .asciiz " ^ "
msg_resp1:      .asciiz "A raiz quadrada de "
msg_resp2:      .asciiz " é igual a "
msg_fim:        .asciiz "Fim\n\n"
msg_space:          .asciiz ", "
     
	.align 2
zeroAsFloat:  .float 0.0 

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
	beq $v0, 7, tabuada
	beq $v0, 8, imc
	beq $v0, 9, fatorial
	beq $v0, 10, fibonacci
	beq $v0, 0, sair

	j menu
	
soma:
	jal ler_num1        
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

        add $a0, $s0, $s1
        move $a1, $s0
        move $a2, $s1

	jal print_result_sum

	j menu

subtracao:
	jal ler_num1
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

	sub $a0, $s0, $s1
	move $a1, $s0
        move $a2, $s1

	jal print_result_sub

	j menu

multiplicacao:
	jal ler_num1
	move $s0, $v0

	jal ler_num2
	move $s1, $v0

	mult $s0, $s1
	mflo $a0
	
	move $a1, $s0
        move $a2, $s1

	jal print_result_mul
	
	# Imprime espaço vazio
        li $v0, 4
        la $a0, msg_n
        syscall

	j menu

divisao:
        jal ler_num1
        move $s0, $v0

	jal ler_num2
	move $s1, $v0

	div $s0, $s1
	mflo $a0
	move $a1, $s0
        move $a2, $s1

	jal print_result_div

	j menu

potencia:
	jal ler_num1
        move $s0, $v0

	jal ler_num2
	move $s1, $v0
	
	# i = 0
        li $t0, 1
        li $a0, 1
          
	potencia_while:
		bgt $t0, $s1, potencia_while_fim
		mult $a0, $s0
		mflo $a0
		addi $t0, $t0, 1      # i++ or i = i + 1
                
		j potencia_while
          potencia_while_fim:
               move $a1, $s0
               move $a2, $s1
               jal print_result_pot

	j menu

raiz:
	jal ler_float
	
	lwc1 $f2, zeroAsFloat
	sqrt.s $f1, $f0
	
	# Imprime uma frase
        li $v0, 4
        la $a0, msg_resp1
        syscall
	
	# Display value
    	li    $v0, 2
     	add.s $f12, $f0, $f2
     	syscall
     	
     	# Imprime uma frase
        li $v0, 4
        la $a0, msg_resp2
        syscall
        
        # Display value
    	li    $v0, 2
     	add.s $f12, $f1, $f2
     	syscall
        
     	# Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall

	j menu

tabuada:
	jal ler_num1
	move $s0, $v0
	move $t2, $zero
	move $a1, $s0
	
	# for(t2 = 0, !(t2 > 10, t2++)
	tabuada_loop_t2:
	        bgt $t2, 10, tabuada_loop_t2_fim
	        
		mult $s0, $t2
		mflo $a0
                move $a2, $t2
                
                jal print_result_mul

		addi $t2, $t2, 1
		
		j tabuada_loop_t2
		
	tabuada_loop_t2_fim:
	        # Imprime espaço vazio
        	li $v0, 4
        	la $a0, msg_n
        	syscall
	        j menu
	        
imc:
	jal ler_massa
	mov.s $f1, $f0
	 
	jal ler_alt
	mov.s $f2, $f0
	
	mul.s $f3, $f2, $f2
	
	div.s $f4, $f1, $f3
	
	# Display message
        li $v0, 4
        la $a0, msg_icmc
        syscall
	
	# Display value
        li $v0, 2
        mov.s $f12, $f4
        syscall
        
        # Display message
        li $v0, 4
        la $a0, msg_nn
        syscall
	
	j menu

fatorial:
	jal ler_num1

	move $t0, $v0
	move $a1, $v0
	
	li $a0, 1   # Resultado do fatorial

	# for(t0 = a0, t0 != 0, t0--)
	fatorial_loop_t3:
		mult $a0, $t0
		mflo $a0

		subi $t0, $t0, 1

		beqz $t0, fatorial_loop_t3_fim
		j fatorial_loop_t3
	fatorial_loop_t3_fim:

	jal print_result_fat

	j menu

fibonacci:
	jal ler_num1
	move $s0, $v0
	addi $s0, $s0, -1
	
	# i = 0
        li $t0, 0
        li $t1, 0
	li $a0, 1
	
	# Começa o while, mas pula a impressão do ", "
	j fibonacci_while_start
	  
        fibonacci_while:
        	jal print_space       #imprime ", "
	fibonacci_while_start:
                jal print_result_fib
                move $t3, $a0
                add $a0, $a0, $t1
                move $t1, $t3
                addi $t0, $t0, 1      # i++ or i = i + 1
                
                bgt $t0, $s0, fibonacci_while_exit
		j fibonacci_while
	fibonacci_while_exit:
	
		li $v0, 4
		la $a0, msg_nn
		syscall

	j menu

sair:
	li $v0, 10
	syscall

# Imprime resultado da soma
print_result_sum:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym_plus
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Imprime resultado da subtracao
print_result_sub:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym3
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Imprime resultado da multiplicacao
print_result_mul:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym4
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_n
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# Imprime resultado da divisao
print_result_div:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym5
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
print_result_pot:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym7
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
print_result_raiz:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym7
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	
# Imprime resultado do fatorial
print_result_fat:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym6
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym_eq
        syscall
        
        # Imprime o resultado
        li $v0, 1
        move $a0, $t0
        syscall
        
        # Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall
        
        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra


print_result_fib:
        # Salva $a0 em $t5 pois $a0 será usado
	move $t5, $a0
	
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
        li $v0, 1
        move $a0, $t5
        syscall

        # Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
          
        jr $ra

print_space:
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_space
        syscall
	
	# Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Le um número e retorna para o $v0
ler_num1:
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num1
        syscall
 
        li $v0, 5
        syscall

	lw $a0, 0($sp)	
	addi $sp, $sp, 4
	
	jr $ra

# Le um número e retorna para o $v0
ler_num2:
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num2
        syscall
 
        li $v0, 5
        syscall

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
ler_float:
	li $v0, 4
        la $a0, msg_float
        syscall
 
        li $v0, 6
        syscall

	jr $ra
	
ler_massa:
	li $v0, 4
        la $a0, msg_massa
        syscall
 
        li $v0, 6
        syscall

	
	jr $ra
	
ler_alt:
	li $v0, 4
        la $a0, msg_alt
        syscall
 
        li $v0, 6
        syscall

	
	jr $ra
