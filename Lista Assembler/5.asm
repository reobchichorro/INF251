li $t1,0
addi $t2,$gp,4
loop: lw $t3,0($t2)
beq $t3,$zero,fim
add $t1,$t1,$t3
addi $t2,$t2,4
jal loop
fim: sw $t1,0($gp)
