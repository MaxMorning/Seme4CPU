.text
MAIN:
sll $0, $0, 0
lw $2, 0($0)
lw $3, 4($0)

# {$2, $4[0]} is the multiplier
addi $4, $0, 0

# result Hi is $5, result Lo is $6
addi $5, $0, 0
addi $6, $2, 0

# $8 control the loop
addi $8, $0, 32

# $9 always = 1
addi $9, $0, 1

# start booth multiply
START_MULT:
andi $7, $6, 1
beq $7, $4, LAST_EQUAL
LAST_NOT_EQUAL:
beq $4, $0, LAST_10
LAST_01:
add $5, $5, $3
j SHIFT_RIGHT
LAST_10:
sub $5, $5, $3
j SHIFT_RIGHT
LAST_EQUAL:
# do nothing
SHIFT_RIGHT:
and $4, $6, 1
srl $6, $6, 1
andi $10, $5, 1 # $10 equals Hi[0], need to send to Lo[31]
sll $10, $10, 31 # $10 become the mask of Lo
or $6, $6, $10
sra $5, $5, 1

sub $8, $8, 1
# srl $6, $6, 1
beq $8, $0, FINISH
j START_MULT
FINISH:
# do nothing
add $0, $0, $0

sw $6, 8($0)
LOOP:
# do nothing
add $0, $0, $0
j LOOP
