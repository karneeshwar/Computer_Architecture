#File Name: Pgm2_Karneeshwar.asm
#Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
#Modification History: 
# a. Code created by Author
# b. 10/18/2021

.data

	Head: 	.asciiz "\nProgramming Assignment CS5330 - Pgm2"			#Heading to be displayed
	fileIn: .ascii ""      												#Variable to store file name from the user
	fileCon:.space 500000												#Variable to store the contents of file
	prompt1:.asciiz "\n\nEnter the file name (< or = 20 characters) :"	#Prompt to ask user for the file name
	output0:.asciiz "\nTotal number of Characters	: "					#Output prompt to show the count of All characters
	output1:.asciiz "\nNumber of Uppercase Characters	: "				#Output prompt to show the count of Uppercase
	output2:.asciiz "\nNumber of Lowercase Characters	: "				#Output prompt to show the count of Lowercase
	output3:.asciiz "\nNumber of Number Symbols		: "					#Output prompt to show the count of Number Symbols
	output4:.asciiz "\nNumber of Other Symbols		: "					#Output prompt to show the count of Other Symbols
	output5:.asciiz "\nNumber of Lines			: "						#Output prompt to show the count of Number for Lines
	output6:.asciiz "\nNumber of Signed Numbers		: "					#Output prompt to show the count of Signed Numbers
    Foot:   .asciiz "\n\nEnd of Results!!!\n" 							#String to display end of results

.text


#Procedures: Main
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Gets the file name from the user, calls several other procedures to perform the statistics and ouputs the results
#Arguments:
#  $v0 For system calls
#  $a0 Starting addresses
#  $t0 Iteration counter
#  $t1 Uppercase counter
#  $t2 Lowercase counter
#  $t3 Number Symbol counter
#  $t4 Other Symbol ocunter
#  $t5 Line counter
#  $t6 Signed Number counter
#  $t7 To store each byte of file during iteration

Main:
	li $v0, 4						#System call for printing string Head
	la $a0, Head					#Load address of Head	
	syscall							#Outputs string Head   

	li $v0, 4                       #System call for printing string prompt1
    la $a0, prompt1                 #Load address of prompt1
    syscall                         #Outputs string promt1

    li $v0, 8						#System call for reading string from user
    la $a0, fileIn                  #Load address of fileIn, variable to store the input to
    li $a1, 20	                    #Defining the maximum length of the input text
    syscall							#Reading the input
	
	jal removeLine					#Procedure to remove the line feed character from the end of the user given file name
    jal readFile            		#Procedure to read the file
    move $s1, $v0           		#Moving to s1 for later use

    li $t0, 0   					#Iteration counter, initializing to 0
    li $t1, 0   					#Uppercase counter, initializing to 0
    li $t2, 0  						#Lowercase counter, initializing to 0
    li $t3, 0  						#Number symbol counter, initializing to 0
    li $t4, 0  						#Other symbol counter, initializing to 0
	li $t5, 0  						#Line counter, initializing to 0
	li $t6, 0  						#Signed number counter, initializing to 0	

Iteration:							#Start of loop to traverse the file
    bge $t0, $s1, quit          	#When end of file is reached, quit the loop
    lb $t7, fileCon($t0)        	#Loading bytes one by one from the file
	
    jal countUpper              	#Procedure to count uppercase
    jal countLower              	#Procedure to count lowercase
    jal countNumber           		#Procedure to count number symbols
	jal countLine					#Procedure to count number of lines
	jal countSigned					#Procedure to count signed numbers
	
    addi $t0, $t0, 1            	#Increment the loop counter by 1

j Iteration							#End of loop

quit:

	sub $t4, $t0, $t1				#Subtract number of uppercase from total number of characters and save to $t4
	sub $t4, $t4, $t2				#Subtract number of lowercase from $t4
	sub $t4, $t4, $t3				#Subtract number of number symbols from $t4 to get final count of other symbols

	#Series of output operations to print the results
	li $v0, 4						#System call for printing string output0	
    la $a0, output0     			#Load address of output0 string
    syscall             			#Outputs string output0
    li $v0, 1           			#System call for printing the count of all characters
    move $a0, $t0					#Storing the Value of $t0 to $a0 for printing
    syscall							#Printing the count of all characters
	
	li $v0, 4						#System call for printing string output1	
    la $a0, output1     			#Load address of output1 string
    syscall             			#Outputs string output1
    li $v0, 1           			#System call for printing the count of Uppercase
    move $a0, $t1					#Storing the Value of $t1 to $a0 for printing
    syscall							#Printing the count of Uppercase

    li $v0, 4						#System call for printing string output2
    la $a0, output2                 #Load address of output2 string
    syscall                         #Outputs string output2
    li $v0, 1						#System call for printing the count of Lowercase
    move $a0, $t2                   #Storing the Value of $t2 to $a0 for printing
    syscall                         #Printing the count of Lowercase

    li $v0, 4						#System call for printing string output3
    la $a0, output3                 #Load address of output3 String
    syscall                         #Outputs string output3
    li $v0, 1						#System call for printing the count of Number symbols
    move $a0, $t3                   #Storing the Value of $t3 to $a0 for printing
    syscall                         #Printing the count of Number symbols

    li $v0, 4						#System call for printing string output4
    la $a0, output4                 #Load address of output4 String
    syscall                         #Outputs string output4
    li $v0, 1						#System call for printing the count of Other symbols
    move $a0, $t4                   #Storing the Value of $t4 to $a0 for printing
    syscall                         #Printing the count of Other symbols
	
	li $v0, 4						#System call for printing string output5
    la $a0, output5                 #Load address of output5 String
    syscall                         #Outputs string output5
    li $v0, 1						#System call for printing the count of Number of lines
    move $a0, $t5                   #Storing the Value of $t5 to $a0 for printing
    syscall                         #Printing the count of Number of lines
	
	li $v0, 4						#System call for printing string output6
    la $a0, output6                 #Load address of output6 String
    syscall                         #Outputs string output6
    li $v0, 1						#System call for printing the count of Signed numbers
    move $a0, $t6                   #Storing the Value of $t6 to $a0 for printing
    syscall                         #Printing the count of Signed numbers
	
    jal closeFile					#Procedure to close the file

	li $v0, 4						#System call for printing string Foot
	la $a0, Foot					#Load address of Foot String
	syscall							#Outputs string Foot

    li $v0, 10						#Termination
    syscall

#Procedures: removeLine
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to remove the line feed character from the end of the user given file name
#Arguments:
#  $t0 Iteration counter
#  $t1 Length of file name
#  $t3 To store each byte of file during iteration

removeLine:							#Procedure to remove the line feed character from the end of the user given file name
    li $t0, 0       				#Loop counter starting at 0
    li $t1, 20      				#Loop end upto the defined length
remove:								#Start of loop remove
    beq $t0, $t1, return			#If the counter reaches the end of the file name length branch and return 
    lb $t3, fileIn($t0)				#Traversing the file name byte by byte
    bne $t3, 0x0a, Incr				#If not equal to line feed branch and increment the loop counter
    sb $zero, fileIn($t0)			#If line feed found, replace it will null character
Incr:							
    addi $t0, $t0, 1				#Increment loop counter
j remove							#End of loop

return:
jr $ra

#Procedures: readFile
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to open and read file

readFile:							#Procedure to open and read file
    # Opening the file
    li   $v0, 13       				#System call for the opening file
    la   $a0, fileIn   				#File name to be opened
    li   $a1, 0        				#Reading flag
    syscall            				#Open the file 
    move $s0, $v0      				#Save the file descriptor 

    # Reading from file just opened
	li $v0, 14       				#System call for reading file
	move $a0, $s0      				#File descriptor 
	la $a1, fileCon  				#Address of fileCon from which to read
	li $a2, 500000	   				#Hardcoded fileCon length
	syscall            				#Read from the file

jr $ra

#Procedures: countUpper
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to count uppercase
#Arguments:
#  $t7 Character to check from the iteration in Main procedure
#  $t1 Uppercase counter

countUpper:							#Procedure to count uppercase
    blt $t7, 0x41, return1          #Branch if less than 'A' and return
    bgt $t7, 0x5a, return1          #Branch if greater than 'Z' and return
    addi $t1, $t1, 1            	#Else increment Uppercase counter

return1:
jr $ra

#Procedures: countLower
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to count lowercase
#Arguments:
#  $t7 Character to check from the iteration in Main procedure
#  $t2 Lowercase counter

countLower:							#Procedure to count lowercase
    blt $t7, 0x61, return2          #Branch if less than 'a' and return
    bgt $t7, 0x7a, return2          #Branch if greater than 'z' and return
    addi $t2, $t2, 1            	#Else increment Lowercase counter
	
return2:	
jr $ra	

#Procedures: countNumber
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to count number symbols
#Arguments:
#  $t7 Character to check from the iteration in Main procedure
#  $t3 Number symbol counter

countNumber:						#Procedure to count number symbols			
    blt $t7, 0x30, return3          #Branch if less than '0' and return                 
    bgt $t7, 0x39, return3          #Branch if greater than '9' and return                 
    addi $t3, $t3, 1            	#Else increment Decimal counter                  
	
return3:	
jr $ra

#Procedures: countUpper
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to count number of lines
#Arguments:
#  $t7 Character to check from the iteration in Main procedure
#  $t5 Line counter

countLine:							#Procedure to count number of lines
	bne $t7, 0x0a, return5			#Branch if not equal to line feed and return
	addi $t5, $t5, 1				#Else increment count

return5:
jr $ra	

#Procedures: countSigned
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021
#Description: Procedure to count number of signed numbers
#Arguments:
#  $t7 Character to check from the iteration in Main procedure
#  $t0 Current position of character to be checked (from main iteration)
#  $t8 Used to find the next charcter in file,  whose position is $t0 + 1
#  $t9 USed to load the next character
#  $t6 Signed number counter

countSigned:						#Procedure to count number of signed numbers
	bne $t7, 0x2b, next				#If character not equal to '+' branch to next
	move $t8, $t0					#Else copy the current position of character in file to $t8
	addi $t8, $t8, 1				#Increment $t8 to indentify the next character in file
	lb $t9, fileCon($t8)			#Load the charcter at $t8
	blt $t9, 0x30 return6			#Check if the character is a number between 0 to 9
	bgt $t9, 0x39 return6			#Branch and return if $t8 is not a number (returning character less than '0' and greater than '9')
	addi $t6, $t6, 1				#Else increment the counter
	
	next:
	bne $t7, 0x2d, return6			#If character not equal to '-' branch to return
	move $t8, $t0                   #Else copy the current position of character in file to $t8
	addi $t8, $t8, 1                #Increment $t8 to indentify the next character in file
	lb $t9, fileCon($t8)            #Load the charcter at $t8
	blt $t9, 0x30 return6           #Check if the character is a number between 0 to 9
	bgt $t9, 0x39 return6           #Branch and return if $t8 is not a number (returning character less than '0' and greater than '9')
	addi $t6, $t6, 1                #Else increment the counter

return6:
jr $ra

#Procedures: closeFile
#Modification History: 
# a. Procedure created by Author
# b. 10/18/2021	
#Description: Procedure to close the file

closeFile:							#Procedure to close the file
    li   $v0, 16       				#System call for close file
    move $a0, $s0      				#File descriptor to close
    syscall            				#Close the file
jr $ra