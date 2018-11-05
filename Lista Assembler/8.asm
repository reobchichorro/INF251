addi $t1,$gp,64 #ponteiro vetor resultado
addi $t2,$gp,0  #ponteiro vetor 1
addi $t3,$gp,32 #ponteiro vetor 2

loop: lw $t5,0($t2)
	lw $t6,0($t3)
	beq $t5,$zero,fim
	beq $t6,$zero,fim
	
	sub $t4,$t5,$t6
	sw $t4,0($t1)
	
	addi $t1,$t1,4
	addi $t2,$t2,4
	addi $t3,$t3,4
jal loop

fim:
