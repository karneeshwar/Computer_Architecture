# File Name: Code_Karneeshwar.asm
# Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
# Modification History: 
#  a. Code create by the Author
#  b. 11/06/2021 
# Procedures:
#  Main: Performs Producer and Comsumer processes based on user input
# Purpose :
# 	A program to illustrate how shared variables are used by two processes through mutual exclusion to update a common buffer which 
# resembles an integrated CPU-GPU system, where CPU acts as a producer, GPU acts as a consumer, and cache acts as the common buffer.
# Reference: 
#	Based on Introduction section in Paper 2 from Bibliography: A Simple Cache Coherence Scheme for Integrated CPU-GPU systems

.data

	mutex: .word 1	# Variable to have Mutual Exclusion between Producer and Consumer Processes
	full: .word 0	# Variable to identify if the buffer is full or not
	empty: .word 3	# Variable to identify if the buffer is empty or not, initially empty is equal to the buffer length, i.e, 3
	item: .word 0	# Variable to show number of items produced or consumed
	
	Head: .asciiz "Term Project CS5330 - Code\n"				# Heading to be displayed
	Option: .asciiz "\nEnter 1 to Produce, 2 to Consume and 3 to Terminate"	# Options for User Input
	UserI: .asciiz "\n\nEnter the process you want to perform: "		# Requesting User Input
	FullPmt: .asciiz "Buffer Full, Can't Produce Item!"			# To prompt user when buffer is full, producer can't produce item
	EmptyPmt: .asciiz "Buffer Empty, Can't Consume Item!"			# To prompt user when buffer is empty, consumer can't consume item
	Produce: .asciiz "Producer Produces Item: "				# To show the item number that the producer produces
	Consume: .asciiz "Consumer Consumes Item: "				# To show the item number that the consumer consumes
	Foot: .asciiz "End of Operation!!!\n"					# To display that the operation has ended
	
.text
Main:
	lw $t1, mutex						# Loading mutex value to register $t1
	lw $t2, full						# Loading full value to register $t2
	lw $t3, empty						# Loading empty value to register $t3
	lw $t4, item						# Loading item value to register $t4
	
	li $v0, 4						# System call for printing string Head
	la $a0, Head						# Load address of Head string	
	syscall							# Outputs string Head
	
	li $v0, 4						# System call for printing string Option
	la $a0, Option						# Load address of Option string
	syscall							# Outputs string Option
	
Iteration:							# To run an infinite loop until the user chooces to terminate
	li $v0, 4						# System call for printing string UserI
	la $a0, UserI						# Load address of UserI string
	syscall							# Outputs string UserI
	
	li $v0, 5						# System call for interger input from user
	syscall							# Inputs the Value from User and Stores it in $v0
	move $t0, $v0						# Storing the Value to $t0
	
	beq $t0, 1, Option1					# If user option is 1, branch to Option1, for producing 
	beq $t0, 2, Option2					# If user option is 2, branch to Option2, for consuming
	beq $t0, 3, Option3					# If user option is 3, branch to Option3, Termination
	bne $t0, 1, NextC					# If user option is not 1
NextC:	bne $t0, 2, NextCA					# And not 2
NextCA:	bne $t0, 3, Iteration					# And not 3, jump to Iteration to prompt the user again to input a valid option
	
Option1:							
	beq $t3, 0, PrintF					# If buffer is full, that is empty = 0, then branch to PrintF
	beq $t1, 1, Producer					# Else, check if mutex = 1, then branch to Producer Process
	
	
Option2:
	beq $t2, 0, PrintE					# If buffer is empty, that is full = 0, then branch to PrintE
	beq $t1, 1, Consumer					# Else check if mutex = 0, then branch to Consumer Process

	
Option3:
	li $v0, 4						# System call for printing string Foot
	la $a0, Foot						# Load address of Foot string	
	syscall							# Outputs string Foot
	
	li $v0, 10						#Termination
        syscall
        
# Function to print that the buffer is full and producer cannot produce more
PrintF:
	li $v0, 4						# System call for printing string FullPmt
	la $a0, FullPmt						# Load address of FullPmt string	
	syscall							# Outputs string FullPmt
	j Iteration

# Function to produce items
Producer:
	sub $t1, $t1, 1						# Decrementing mutex to 0 as Producer is runnning now
	add $t2, $t2, 1						# Incrementing full by 1 as Producer produced 1 item now				
	sub $t3, $t3, 1						# Decrenenting empty by 1 as Producer used 1 space in buffer
	add $t4, $t4, 1						# Incrementing item by 1 to keep count of number of items produced
	
	li $v0, 4						# System call for printing string Produce
	la $a0, Produce						# Load address of Produce string	
	syscall							# Outputs string Produce
	li $v0, 1						# System call for printing the Item number
	move $a0, $t4						# Storing the Value of Item to $a0 for printing
	syscall							# Outputs the value of Item
	
	addi $t1, $t1, 1					# Incrementing mutex to 1 again as Producer has finished running
	j Iteration						# Jump back to Iteration to get user input again

# Function to print that the buffer is empty and consumer cannot consume more	
PrintE:
	li $v0, 4						# System call for printing string EmptyPmt
	la $a0, EmptyPmt					# Load address of EmptyPmt string	
	syscall							# Outputs string EmptyPmt
	j Iteration

# Function to consume items	
Consumer:
	sub $t1, $t1, 1						# Decrementing mutex to 0 as Consumer is runnning now
	sub $t2, $t2, 1						# Decrementing full by 1 as Consumer consumed 1 item now
	add $t3, $t3, 1						# Incrementing empty by 1 as Consumer has created a free space in buffer
	
	li $v0, 4						# System call for printing string Consume
	la $a0, Consume						# Load address of Consume string	
	syscall							# Outputs string Consume
	li $v0, 1						# System call for printing the Item number
	move $a0, $t4						# Storing the Value of Item to $a0 for printing
	syscall							# Outputs the value of Item
	
	sub $t4, $t4, 1						# Decrementing item by 1 as Consumed item doesn't exit now
	
	addi $t1, $t1, 1					# Incrementing mutex to 1 again as Consumer has finished running
	j Iteration						# Jump back to Iteration to get user input again