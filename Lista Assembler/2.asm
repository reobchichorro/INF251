add $t1,$zero,$gp
add $t2,$zero,$zero
loop1: beq $t2,2,endloop1
	
	addi $t3,$t1,4
	addi $t4,$t2,1
	loop2:
	lw $t5,0($t1)
	lw $t6,0($t3)
	beq $t4,3,endloop2
	
	
	bge $t5,$t6,endif
		add $t7,$zero,$t6
		add $t6,$zero,$t5
		add $t5,$zero,$t7
		
		sw $t5,0($t1)
		sw $t6,0($t3)
	endif:
	
	
	addi $t3,$t3,4
	addi $t4,$t4,1
	jal loop2
	endloop2:
	
addi $t1,$t1,4
addi $t2,$t2,1
jal loop1
endloop1: