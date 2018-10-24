# Credits to Amanda Brooks, both for contributing about half this program, and for saving the code for years which saved the project because I am  a lazy POS and didn't save my own copy. 10/10 person.

.data 
skeleton:	.asciiz	" 1 # 2 # 3 \n###########\n 4 # 5 # 6 \n###########\n 7 # 8 # 9 \n"
promptX:	.asciiz " Player 1 move: "
promptO:	.asciiz " Player 2 move: "
newLine:	.asciiz "\n"
winX:		.asciiz "Player 1 is the winner!"
winO:		.asciiz "Player 2 is the winner!"
noWin:		.asciiz "The game is a draw."
xMove:		.space	20
yMove:		.space	20
turnCounter:	.word	10
count:		.float	1
hold1:		.float	0
hold2:		.float	1

.text

	l.s	$f0,hold1
	l.s	$f3,hold1
	l.s	$f8,count
	l.s	$f9,count
	
	li	$t9, 0

promptPlayer1:

	li	$v0,4
	la	$a0,skeleton
	syscall
	
	c.eq.s	$f8,$f9
	#prompt players for moves
	li	$v0,4
	la	$a0,promptX
	syscall
	
	#get number from input
	li	$v0,5
	syscall
	move $t1, $v0
	
	#checking if number is greater than 9 or less than 1, if so, loop back to start of prompt
	bgt $t1, 9, promptPlayer1
	blt $t1, 1, promptPlayer1
	
	#put move into stack then input
	sub	$sp,$sp,4
	sw	$t1,0($sp)
	l.s	$f0,hold1
	addi	$t9,$t9,1
	j	input1
	
promptPlayer2:
	beq $t9, 9, draw
	
	li	$v0,4
	la	$a0,skeleton
	syscall
	
	c.eq.s	$f8,$f9
	li	$v0,4
	la	$a0,promptO
	syscall
	
	li	$v0,5			#get number from input
	syscall
	move $t2, $v0
	
	bgt $t2, 9, promptPlayer2	#checking if number is greater than 9 or less than 1, if so, loop back to start of prompt
	blt $t2, 1, promptPlayer2
	
	#put move into stack then input
	sub	$sp,$sp,4
	sw	$t2,0($sp)
	l.s	$f0,hold2
	addi	$t9,$t9,1
	j	input2
	
input1:
	add 	$a0,$0,$0
	add	$t1,$t1,48
	loop1:
	lb	$a2,skeleton($a0)
	beq	$a2,$t1,replace1
	addiu	$a0,$a0,1
	bne	$a0,$a1,loop1

	replace1:
	lb	$a3,skeleton($a0)
	addi	$a3,$0,120
	sb	$a3,skeleton($a0)
	
	
	j	check
	
input2:
	add	$a0,$0,$0
	add	$t2,$t2,48
	loop2:
	lb	$a2,skeleton($a0)
	beq	$a2,$t2,replace2
	addiu	$a0,$a0,1
	bne	$a0,$a1,loop2
	
	replace2:
	lb	$a3,skeleton($a0)
	addi	$a3,$0,111
	sb	$a3,skeleton($a0)
	
	j	check
	

end:
	c.lt.s	$f3,$f0
	bc1f	promptPlayer2
	bc1t	promptPlayer1


check:
	blt	$t9,5,end
	 #if 1 = 1+4 = 1+8 or 25 = 25+4 = 25+8 or 49 = 49+4 = 49+8
	li 	$t5, 1
horiz:	lb 	$t6, skeleton($t5)
	addi	$t5, $t5, 4
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, hori2
	addi	$t5, $t5, 4
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
hori2:	
	addi    $t5, $0, 25
	lb 	$t6, skeleton($t5)
	addi	$t5, $t5, 4
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, hori3
	addi	$t5, $t5, 4
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
hori3:
	addi    $t5, $0, 49
	lb 	$t6, skeleton($t5)
	addi	$t5, $t5, 4
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, vert
	addi	$t5, $t5, 4
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win

vert:	#if 1 = 1+24 = 1+48 or 5 = 5+24 = 5+28 or 9 = 9+24 = 9+48
	addi 	$t5, $0, 1
	lb	$t6, skeleton($t5)
	addi 	$t5, $t5, 24
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, vert2
	addi	$t5, $t5, 24
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
	
vert2: 	addi	$t5, $0, 5
	lb	$t6, skeleton($t5)
	addi 	$t5, $t5, 24
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, vert3
	addi	$t5, $t5, 24
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
	
vert3:	addi	$t5, $0, 9
	lb	$t6, skeleton($t5)
	addi 	$t5, $t5, 24
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, diag
	addi	$t5, $t5, 24
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win

diag:	#if 1 = 29 = 57 or if 9 = 29 = 49
	addi	$t5, $0, 1
	lb	$t6, skeleton($t5)
	addi 	$t5, $0, 29
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, diag2
	addi	$t5, $0, 57
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
	
diag2:	addi	$t5, $0, 9
	lb	$t6, skeleton($t5)
	addi 	$t5, $t5, 29
	lb	$t7, skeleton($t5)
	bne	$t6, $t7, end
	addi	$t5, $t5, 49
	lb 	$t7, skeleton($t5)
	beq	$t6, $t7, win
	j end
	
win:

	li	$v0,4
	la	$a0,skeleton
	syscall
	
	#if $t7 = X output X win, otherwise print O win
	li	$v0, 4
	bne	$t7, 'x', Owin
	la	$a0, winX
	syscall
	j	exit
Owin:	la	$a0, winO
	syscall
	j 	exit
draw: 	li 	$v0, 4
	la	$a0, noWin
	syscall
exit:	

	li 	$v0, 10
	syscall
