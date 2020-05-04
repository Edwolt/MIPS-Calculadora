# 1o Trabalho Pratico
# Autores:
# Nome: Fabio Dias da Cunha    N°USP: 11320874
# Nome: Eduardo Souza Rocha    N°USP: 11218692
                
                .data
	        .align 0
	        
msg_menu:	.asciiz "Escolha uma opção: \n1-Soma\n2-Subtração\n3-Multiplicação\n4-Divisão\n5-Potência\n6-Raiz Quadrada\n7-Tabuada\n8-IMC\n9-Fatorial\n10-Sequência de Fibonacci\n0-Sair\n"         
msg_num1:	.asciiz "Digite um número inteiro:\n"
msg_num2:	.asciiz "Digite outro número inteiro:\n"
msg_num3:       .asciiz "Digite um número real:\n"
msg_num4:       .asciiz "Digite a massa(Kg): \n"
msg_num5:       .asciiz "Digite a altura(m): \n"
msg_num6:       .asciiz "O IMC é igual a: "
msg_n:		.asciiz "\n"
msg_nn:		.asciiz "\n\n"
msg_sym1:       .asciiz " = "
msg_sym2:       .asciiz " + "
msg_sym3:       .asciiz " - "
msg_sym4:       .asciiz " x "
msg_sym5:       .asciiz " / "
msg_sym6:       .asciiz "!"
msg_sym7:       .asciiz " ^ "
msg_resp1:      .asciiz "A raiz quadrada de "
msg_resp2:      .asciiz " é igual a "
msg_fim:        .asciiz "Fim\n\n"
msg_space:      .asciiz ", "
msg_erro:       .asciiz "Parâmetro(s) inválido(s).\n\n"
     
	        .align 2
	        
zeroAsFloat:    .float 0.0 

	        .text
	        .globl main 

main:
	j menu # jump incondicional para o menu
	 
menu:
        # Exibe para o usuario as opcoes disponiveis no menu
	li $v0, 4
	la $a0, msg_menu
	syscall

	# Le a opcao que o usuario vai selecionar
	li $v0, 5
	syscall

	# Jump condicional para as operacoes
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
        # Eu escolhi esse intervalo , porque é a raiz aproximada do maior número que podemos representar: -2.147.483.648 a 2.147.483.647
        li $t7, 46340
        li $t8, -46340
        
	jal ler_num1
	move $s0, $v0
	
	bgt $s0, $t7, erro
	blt $s0, $t8, erro

	jal ler_num2
	move $s1, $v0
	
	bgt $s1, $t7, erro
	blt $s1, $t8, erro

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
        li $t7, 46340
        li $t8, -46340
        
        jal ler_num1
        move $s0, $v0
        
        bgt $s0, $t7, erro
	blt $s0, $t8, erro

	jal ler_num2
	move $s1, $v0
	
	bgt $s1, $t7, erro
	blt $s1, $t8, erro
	beq $s1, $zero, erro

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
	
	move $a1, $s0
	move $a2, $s1
	bltz $s1, potException
	
	# i = 0
        li $t0, 1
        li $a0, 1
          
          while1:
                bgt $t0, $s1, exit1
                mult $a0, $s0
                mflo $a0
                addi $t0, $t0, 1      # i++ or i = i + 1
                
                j while1
          exit1:
               move $a1, $s0
               move $a2, $s1
               jal print_result_pot
               
	j menu

potException:
        move $s0, $a1
        move $s1, $a2
        move $t2, $a2
        
        li $t0, -1
        mult $t0, $s1
	mflo $s1
        
          
        # i = 0
        li $t0, 1
        li $a0, 1  
        
          while2:
                bgt $t0, $s1, exit2
                mult $a0, $s0
                mflo $a0
                addi $t0, $t0, 1      # i++ or i = i + 1
                
                j while2
          exit2:
               li $t0, 1
               div $t0, $a0
               mflo $a0
               move $a1, $s0
               move $a2, $t2
               jal print_result_pot
               
	j menu

raiz:
	jal ler_float
	lwc1 $f2, zeroAsFloat
	
	# Verifica se o número é menor que zero
	c.lt.s $f0, $f2
	bc1t erro
	
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
	
	# for(t0 = 0, t0 != 10, t0++)
	loop_t2:
	        bgt $t2, 10, loop_t2_fim
	        
		mult $s0, $t2
		mflo $a0
                move $a2, $t2
                
                jal print_result_mul

		addi $t2, $t2, 1
		
		j loop_t2
		
	loop_t2_fim:
	        # Imprime espaço vazio
        	li $v0, 4
        	la $a0, msg_n
        	syscall
	        j menu
	        
imc:
        lwc1 $f1, zeroAsFloat
        
        # Le o numero e verifica se o número é menor que zero
	jal ler_massa
	c.lt.s $f0, $f1
	bc1t erro
	
	add.s $f2, $f0, $f1
	 
	# Le o numero e verifica se o número é menor que zero
	jal ler_alt
	c.le.s $f0, $f1
	bc1t erro
	
	add.s $f3, $f0, $f1
	
	mul.s $f4, $f3, $f3
	
	div.s $f5, $f2, $f4
	
	# Display message
        li $v0, 4
        la $a0, msg_num6
        syscall
	
	# Display value
        li    $v0, 2
        add.s $f12, $f1, $f5
        syscall
        
        # Display message
        li $v0, 4
        la $a0, msg_nn
        syscall
	
	j menu

fatorial:
	jal ler_num1
	li $t8, 12
	
	bltz $v0, erro
	bgt $v0, $t8, erro

	move $t0, $v0
	move $a1, $v0
	
	li $a0, 1   # Resultado do fatorial

	# for(t0 = a0, t0 != 0, t0--)
	loop_t3:
	        beq $t0, $zero, loop_t3_fim
		
		mult $a0, $t0
		mflo $a0

		subi $t0, $t0, 1

		j loop_t3
	loop_t3_fim:

	jal print_result_fat

	j menu

fibonacci:
	jal ler_num1
	li $t8, 45
	
	bltz $v0, erro
	bgt $v0, $t8, erro
	
	move $s0, $v0
	addi $s0, $s0, -1
	
	# i = 0
        li $t0, 0
        li $t1, 0
        li $a0, 1
          
          while:
                bgt $t0, $s0, exit
                jal print_result_fib
                move $t3, $a0
                add $a0, $a0, $t1
                move $t1, $t3
                addi $t0, $t0, 1      # i++ or i = i + 1
                
                j while
          exit:
               li $v0, 4
               la $a0, msg_fim
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
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)

	# Imprime o primeiro numero
	li $v0, 1
        move $a0, $a1
        syscall
        
        # Imprime o simbolo de operacao
	li $v0, 4
        la $a0, msg_sym2
        syscall
        
        # Imprime o segundo numero
	li $v0, 1
        move $a0, $a2
        syscall
        
        # Imprime o simbolo de igualdade
	li $v0, 4
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

# Imprime resultado da subtracao
print_result_sub:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

# Imprime resultado da multiplicacao
print_result_mul:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
# Imprime resultado da divisao
print_result_div:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

# Imprime resultado da potenciação
print_result_pot:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
# Imprime resultado da radiciação
print_result_raiz:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra
	
# Imprime resultado do fatorial
print_result_fat:
	# Salva $a0 em $t0 pois $a0 será usado
	move $t0, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
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
        la $a0, msg_sym1
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
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	
	jr $ra

# Imprime a sequência de fibonacci até determinado número
print_result_fib:
        # Salva $a0 em $t5 pois $a0 será usado
	move $t5, $a0
	
	# Empilha
	subi $sp, $sp, 8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
        li $v0, 1
        add $a0, $zero, $t5
        syscall
          
        li $v0, 4
        la $a0, msg_space
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
	
# Le um float e retorna para o $f0
ler_float:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	li $v0, 4
        la $a0, msg_num3
        syscall
 
        li $v0, 6
        syscall

	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	
	jr $ra
	
# Le um float e retorna para o $f0
ler_massa:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	li $v0, 4
        la $a0, msg_num4
        syscall
 
        li $v0, 6
        syscall

	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	
	jr $ra
	
# Le um float e retorna para o $f0
ler_alt:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	li $v0, 4
        la $a0, msg_num5
        syscall
 
        li $v0, 6
        syscall

	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	
	jr $ra

erro:
	li $v0, 4
	la $a0, msg_erro
	syscall
	
	j menu
