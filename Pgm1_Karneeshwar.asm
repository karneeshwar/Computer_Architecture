# File Name: Pgm1_Karneeshwar.asm
# Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
# Modification History: 
#  a. Few lines of comments added by author, lines 88 to 91
#  b. 9/12/2021
# Modification History: 
#  a. Code create by the Author
#  b. 9/11/2021 
# Procedures:
#  UserI: Gets the values of two integers A and B from the user, and stores them
#  Calc: Calculates basic arithmetic operations such as A+B, A-B, B-A, A*B, A/B, and B/A, and prints the results

	.data
	
	Head: .asciiz "Programming Assignment CS5330 - Pgm1\n\n"	# Heading to be displayed
	
	Request1: .asciiz "Enter the Value of A: "		# String to promt the user requesting the Value of A
	Request2: .asciiz "Enter the Value of B: "		# String to promt the user requesting the Value of B
	AplusB:	.asciiz "\nThe Value of A+B     = "		# String to label the results of A+B
	AminusB: .asciiz "\nThe Value of A-B     = " 		# String to label the results of A-B
	BminusA: .asciiz "\nThe Value of B-A     = " 		# String to label the results of B-A
	AtimesB: .asciiz "\nThe Value of A*B     = " 		# String to label the results of A*B
	AbyBQ: .asciiz "\nThe Quotient of A/B  = "		# String to label the results of quotient of A/B
	AbyBR: .asciiz "\nThe Remainder of A/B = "		# String to label the results of remainder of A/B
	noAbyB: .asciiz "\nA/B can't be done as B is 0"	# String to label that A/B can't be performed
	BbyAQ: .asciiz "\nThe Quotient of B/A  = "		# String to label the results of quotient of B/A
	BbyAR: .asciiz "\nThe Remainder of B/A = "		# String to label the results of remainder of B/A
	noBbyA: .asciiz "\nB/A can't be done as A is 0"	# String to label that B/A can't be performed
	
	end: .asciiz "\n\nEnd of code!!!\n" 			# String to display end of code/output
	
	.text
	
	li $v0, 4						# System call for printing string Head
	la $a0, Head						# Load address of Head prompt	
	syscall							# Outputs string Head
	
# Procedure: UserI
# Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
# Modification History: 
#  a. Code create by the Author
#  b. 9/11/2021
# Description: Gets the values of two integers A and B from the user, and stores them
# Arguments:
#  $v0 For system calls
#  $a0 Starting address of request prompts
#  $t0 Storing the Value of A
#  $t1 Storing the Value of B
UserI:
# Request the user to enter the value of A
	li $v0, 4						# System call for printing string Request1
	la $a0, Request1					# Load address of Request1 prompt	
	syscall							# Outputs string Request1
	
# Get the value of A
	li $v0, 5						# System call for interger input from user
	syscall							# Inputs the Value of A from the user and stores it in $v0
	move $t0, $v0						# Storing the Value of A to $t0
	
# Request the user to enter the Value of B
	li $v0, 4						# System call for printing string Request2
	la $a0, Request2					# Load address of Request2 prompt
	syscall							# Outputs string Request2
	
# Get the Value of B
	li $v0, 5						# System call for interger input from user
	syscall							# Inputs the Value of B from the user and stores it in $v0
	move $t1, $v0						# Storing the Value of B to $t1
	
# Procedure: Calc
# Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
# Modification History: 
#  a. Few lines of comments added by author, lines 88 to 91
#  b. 9/12/2021
# Modification History: 
#  a. Code create by the Author
#  b. 9/11/2021
# Description: Calculates basic arithmetic operations such as A+B, A-B, B-A, A*B, A/B, and B/A, and prints the results
# Arguments:
#  $v0 For system calls
#  $a0 Load address of results from each arithmetic operations
#  $t0 Stored Value of A
#  $t1 Stored Value of B
#  $t2 Storing the Value of A+B
#  $t3 Storing the Value of A-B
#  $t4 Storing the Value of B-A
#  $t5 Storing the Value of A*B
#  $s0 Storing the Quotient of A/B
#  $s1 Storing the Remainder of A/B
#  $s2 Storing the Quotient of B/A
#  $s3 Storing the Quotient of B/A

Calc:

#A+B	
	li $v0, 4						# System call for printing string AplusB
	la $a0, AplusB						# Load address of AplusB String
	syscall							# Outputs string AplusB
	add $t2, $t0, $t1					# $t2 = $t0 + $t1 ( => A+B) sum of A and B
	li $v0, 1						# System call for printing integer A+B
	move $a0, $t2						# Storing the Value of A+B to $a0 for printing
	syscall							# Outputs the value of AplusB
	
#A-B	
	li $v0, 4						# System call for printing string AminusB
	la $a0, AminusB						# Load address of AminusB String
	syscall							# Outputs string AminusB
	sub $t3, $t0, $t1					# $t3 = $t0 - $t1 ( => A-B) difference of A and B
	li $v0, 1						# System call for printing integer A-B
	move $a0, $t3						# Storing the Value of A-B to $a0 for printing
	syscall							# Outputs the value of AminusB
	
#B-A	
	li $v0, 4						# System call for printing string BminusA
	la $a0, BminusA						# Load address of BminusA String
	syscall							# Outputs string BminusA
	sub $t4, $t1, $t0					# $t4 = $t1 - $t0 ( => B-A) difference of B and A
	li $v0, 1						# System call for printing integer B-A
	move $a0, $t4						# Storing the Value of B-A to $a0 for printing
	syscall							# Outputs the value of BminusA
	
#A*B
	li $v0, 4						# System call for printing string AtimesB
	la $a0, AtimesB						# Load address of AtimesB String
	syscall							# Outputs string AtimesB
	mul $t5, $t0, $t1					# $t5 = $t0 * $t1 ( => A*B) product of A and B
	li $v0, 1						# System call for printing integer A*B
	move $a0, $t5						# Storing the Value of A*B to $a0 for printing
	syscall							# Outputs the value of AtimesB
	
#A/B
	beq $t1, $zero, else1					# if B = 0, branch to else1 
	
	div $t0, $t1						# $t0 / $t1 ( => A/B) lo = Quotient & hi = Remainder
	mflo $s0						# Storing value of Quotient from lo to $s0
	mfhi $s1						# Storing value of Remainder from hi to $s1
	li $v0, 4						# System call for printing string AbyBQ
	la $a0, AbyBQ						# Load address of AbyBQ String
	syscall							# Outputs string AbyBQ
	li $v0, 1						# System call for printing integer Quotient of A/B
	move $a0, $s0						# Storing the Value of Quotient to $a0 for printing
	syscall							# Outputs the value of Quotient of A/B
	li $v0, 4						# System call for printing string AbyBR
	la $a0, AbyBR						# Load address of AbyBR String
	syscall							# Outputs string AbyBR
	li $v0, 1						# System call for printing integer Remainder of A/B
	move $a0, $s1						# Storing the Value of Remainder to $a0 for printing
	syscall							# Outputs the value of Remainder of A/B
	j exit1							
	
else1:	li $v0, 4						# System call for printing string noAbyB
	la $a0, noAbyB						# Load address of noAbyB String
	syscall							# Outputs string noAbyB
	
exit1:
#B/A
	beq $t0, $zero, else2					# if A = 0, branch to else2

	div $t1, $t0						# $t1 / $t0 ( => B/A) lo = Quotient & hi = Remainder
	mflo $s2						# Storing value of Quotient from lo to $s2
	mfhi $s3						# Storing value of Remainder from hi to $s3
	li $v0, 4						# System call for printing string BbyAQ
	la $a0, BbyAQ						# Load address of BbyAQ String
	syscall							# Outputs string BbyAQ
	li $v0, 1						# System call for printing integer Quotient of B/A
	move $a0, $s2						# Storing the Value of Quotient to $a0 for printing
	syscall							# Outputs the value of Quotient of B/A
	li $v0, 4						# System call for printing string BbyAR
	la $a0, BbyAR						# Load address of BbyAR String
	syscall							# Outputs string BbyAR
	li $v0, 1						# System call for printing integer Remainder of B/A
	move $a0, $s3						# Storing the Value of Remainder to $a0 for printing
	syscall							# Outputs the value of Remainder of B/A
	j exit2

else2:	li $v0, 4						# System call for printing string noBbyA
	la $a0, noBbyA						# Load address of noBbyA String
	syscall							# Outputs string noBbyA
	
exit2:

	li $v0, 4						# System call for printing string end
	la $a0, end						# Load address of end String
	syscall							# Outputs string end

	
