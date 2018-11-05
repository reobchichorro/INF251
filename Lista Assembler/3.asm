li $t1,0 # t1 resultado = 0
lw $t2,4($gp) # t2 = m[gp+4]
lw $t3,8($gp) # t3 = m[gp+8]

blt $t3,0,inverter #if t3 < 0

loop: add $t1,$t1,$t2 # m = t2+....
addi $t3,$t3,-1 # t3 --
beq $t3,$zero,fim # $t3 == 0
jal loop # soma mais um termo

inverter: sub $t1,$t1,$t2 # m = t2+....
addi $t3,$t3,1 # t3 --
beq $t3,$zero,fim # $t3 == 0
jal inverter # soma mais um 

fim: sw $t1,0($gp) # grava resultado
