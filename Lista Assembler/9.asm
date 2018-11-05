li $t1,0
addi $t2,$gp,4  #ponteiro vetor 1
addi $t3,$gp,32 #ponteiro vetor 2

loop: lw $t4,0($t2)
	lw $t5,0($t3)
	beq $t4,$zero,fim
	beq $t5,$zero,fim
	
	blt $t4,$t5,increment
	continue:
	addi $t2,$t2,4
	addi $t3,$t3,4
jal loop

increment: addi $t1,$t1,1
jal continue

fim: sw $t1,0($gp)


