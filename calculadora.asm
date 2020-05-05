# 1o Trabalho Pratico
# Autores:
# Nome: Fabio Dias da Cunha    N°USP: 11320874
# Nome: Eduardo Souza Rocha    N°USP: 11218692
                
                .data
	        .align 0

msg_menu:	.asciiz "Escolha uma opção: \n1-Soma\n2-Subtração\n3-Multiplicação\n4-Divisão\n5-Potência\n6-Raiz Quadrada\n7-Tabuada\n8-IMC\n9-Fatorial\n10-Sequência de Fibonacci\n0-Sair\n"         
msg_num1:	.asciiz "Digite um número inteiro:\n"
msg_num2:	.asciiz "Digite outro número inteiro:\n"
msg_float:      .asciiz "Digite um número real:\n"
msg_massa:      .asciiz "Digite a massa(Kg): \n"
msg_alt:        .asciiz "Digite a altura(m): \n"
msg_icmc:       .asciiz "O IMC é igual a: "
msg_n:		.asciiz "\n"
msg_nn:		.asciiz "\n\n"
msg_sym_eq:     .asciiz " = "
msg_sym_sum:    .asciiz " + "
msg_sym_menos:  .asciiz " - "
msg_sym_mul:    .asciiz " x "
msg_sym_div:    .asciiz " / "
msg_sym_fat:    .asciiz "!"
msg_sym_pot:    .asciiz " ^ "
msg_res_raiz:   .asciiz "A raiz quadrada de "
msg_res_igual:  .asciiz " é igual a "
msg_space:      .asciiz ", "
msg_erro:       .asciiz "Parâmetro(s) inválido(s).\n\n"
msg_overflow:   .asciiz "O resultado é um número muito grande, e não pode ser calculado.\n\n"
		.align 2
float_zero:     .float 0.0

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

	j menu   # Caso não seja nenhuma das opções, volta para o menu


##########################
##### Opções do Menu #####
##########################
	
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
        # Eu escolhi esse intervalo , porque eh a raiz aproximada do maior número que podemos representar: -2.147.483.648 a 2.147.483.647
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
	bltz $s1, potneg
	
	# i = 0
        li $t0, 1
        li $a0, 1
        
        # while(!($t0 > $s1))
	potencia_while:
		bgt $t0, $s1, potencia_while_fim
		
		mult $a0, $s0
		
		#Verifica overflow
		mfhi $t1
		bnez $t1, overflow
		
		mflo $a0
		
		addi $t0, $t0, 1      # $t0++ ou $t0 = $t0 + 1
                
		j potencia_while
	potencia_while_fim:

	move $a1, $s0
	move $a2, $s1
	jal print_result_pot
               
	j menu

potneg:
        move $s0, $a1
        move $s1, $a2
        move $t2, $a2
        
        li $t0, -1
        mult $t0, $s1
	mflo $s1
        
          
        # i = 0
        li $t0, 1
        li $a0, 1  
        
        potneg_while:
                bgt $t0, $s1, potneg_while_end
                mult $a0, $s0
                mflo $a0
                addi $t0, $t0, 1      # i++ or i = i + 1
                
                j potneg_while
        potneg_while_end:
               li $t0, 1
               div $t0, $a0
               mflo $a0
               move $a1, $s0
               move $a2, $t2
               jal print_result_pot
               
	j menu

raiz:
	lwc1 $f5, float_zero

	jal ler_float
	c.lt.s $f0, $f5
	bc1t erro
	
	sqrt.s $f1, $f0
	
	# Imprime uma frase
        li $v0, 4
        la $a0, msg_res_raiz
        syscall
	
	# Display value
    	li    $v0, 2
     	mov.s $f12, $f0
     	syscall
     	
     	# Imprime uma frase
        li $v0, 4
        la $a0, msg_res_igual
        syscall
        
        # Display value
    	li    $v0, 2
     	mov.s $f12, $f1
     	syscall
        
     	# Imprime espaço vazio
        li $v0, 4
        la $a0, msg_nn
        syscall

	j menu

tabuada:
	jal ler_num1
	move $s0, $v0
	move $s1, $zero
	move $a1, $s0
	
	# Estou usando s1 como iterador para o seu valor não ser sobrescrito com a chamada de função
	# for($s1 = 0, !($s1 > 10, $s1++)
	tabuada_loop_t2:
	        bgt $s1, 10, tabuada_loop_t2_fim
	        
		mult $s0, $s1
		mflo $a0
                move $a2, $s1
                
                jal print_result_mul

		addi $s1, $s1, 1   # $s1++
		
		j tabuada_loop_t2
		
	tabuada_loop_t2_fim:
	        # Imprime espaço vazio
        	li $v0, 4
        	la $a0, msg_n
        	syscall
	        j menu
	        
imc:       
	lwc1 $f5, float_zero 
        # Le o numero e verifica se o número é menor que zero
	jal ler_massa
	c.le.s $f0, $f5
	bc1t erro
	
	mov.s $f1, $f0   # Salva valor em $f1
	  
	# Le o numero e verifica se o número é menor que zero
	jal ler_alt
	c.lt.s $f0, $f5
	bc1t erro
	
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
	li $t8, 12
	
	bltz $v0, erro
	bgt $v0, $t8, erro

	move $t0, $v0 # iterador
 	move $a1, $v0
	
	li $a0, 1   # Resultado do fatorial
	beqz  $v0, fatorial_loop_t3_fim
	
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

	move $s0, $v0 # Iterador
	li $t8, 45
	
	bltz $v0, erro
	bgt $v0, $t8, erro
	beqz $v0, fibonacci_while_exit
	
        li $s1, 1
	li $s2, 0
	
	# Começa o while, mas pula a impressão do ", "
	j fibonacci_while_start
	  
        fibonacci_while:
        	jal print_space       #imprime ", "
	fibonacci_while_start:
                move $a0, $s1
                jal print_result_fib

                move $t3, $s1
                add $s1, $s1, $s2
                move $s2, $t3
                
                subi $s0, $s0, 1
                beqz $s0, fibonacci_while_exit
		j fibonacci_while
	fibonacci_while_exit:
	
		li $v0, 4
		la $a0, msg_nn
		syscall

	j menu

sair:
	li $v0, 10
	syscall


###################
##### Funções #####
###################

# Imprime resultado da soma $a1 + $a2 = $a0
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
        la $a0, msg_sym_sum
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

# Imprime resultado da subtração $a1 - $a2 = $a0
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
        la $a0, msg_sym_menos
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

# Imprime resultado da multiplicação $a1 * $a2 = $a0
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
        la $a0, msg_sym_mul
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
	
# Imprime resultado da divisão $a1 / $a2 = $a0
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
        la $a0, msg_sym_div
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

# Imprime o resultado da potênciação $a1 ^ $a2 = $a0
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
        la $a0, msg_sym_pot
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
        la $a0, msg_sym_fat
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

# Imprime a sequência de fibonacci até determinado número
print_result_fib:
        li $v0, 1
        syscall

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
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num1
        syscall
 
        li $v0, 5
        syscall

	# Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# Le um número e retorna para o $v0
ler_num2:
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_num2
        syscall
 
        li $v0, 5
        syscall

	# Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
# Le um float e retorna para o $f0
ler_float:
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	
	li $v0, 4
        la $a0, msg_float
        syscall
 
        li $v0, 6
        syscall

	# Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4

	jr $ra
  
# Le uma massa (float) e retorna para o $f0
ler_massa:
	li $v0, 4
        la $a0, msg_massa
        syscall
 
        li $v0, 6
        syscall

	
	jr $ra
 
# Le um altura (float) e retorna para o $f0
ler_alt:
	# Empilha
	subi $sp, $sp, 4
	sw $a0, 0($sp)

	li $v0, 4
        la $a0, msg_alt
        syscall
 
        li $v0, 6
        syscall

	# Desempilha
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

###########################
#### Mensagem de erro #####
###########################

erro:
	li $v0, 4
	la $a0, msg_erro
	syscall
	
	j menu

overflow:
	li $v0, 4
	la $a0, msg_overflow
	syscall
	
	j menu
