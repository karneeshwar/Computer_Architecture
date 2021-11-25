#File Name: Pgm3_Karneeshwar.asm
#Author: Karneeshwar, Sendilkumar Vijaya - Graduate Student in CS at UT Dallas
#Modification History: 
# c. outputOperations: added in Main on 11/18/2021 based on suggestions from Professor Dr. Richard A. Goodrum, Ph.D
# b. Procedures nextByte, nextValue, findBase, and convertInteger were added to the code on 11/13/2021 based on suggestions from Professor Dr. Richard A. Goodrum, Ph.D
# a. Code created by Author on 11/11/2021

.data
        Head:                   .asciiz "\nProgramming Assignment CS5330 - Pgm3\n"      # Heading to be displayed
        colonSpaceIP:           .asciiz ": "                                            # Colon followed by space for displaying input and output values
        semiColonSpaceOP:       .asciiz "; "                                            # Semicolon followed by space for displaying after input
        newlineChar:            .asciiz "\n"                                            # New line character used for checking end of line
        prompt1:                .asciiz "\n\nEnter the file name to be read: "          # Prompt to ask user for the file name
        fileInLength:           .word   128                                             # Space to store the length of file name
        fileIn:                 .space  128                                             # Space to store file name from the user
        fileCon:                .space  1                                               # Space to hold each byte from the file
        conLength:              .word   1                                               # Length of data read from file
        opValue:                .space  41                                              # Space to hold the output values, binaries are displayed in 32 bits + spaces and commas
        Foot:                   .asciiz "\n\nEnd of Results!!!\n"                       # String to display end of results


.text

#Procedures: Main
#Modification History:
# b. outputOperations: added in Main on 11/18/2021
# a. Procedure created by Author on 11/11/2021
#Description: Gets the file name from the user, calls several other procedures to perform the required calculation, displays results and terminates
#Arguments:
#  $v0 For system calls
#  $a0 Starting addresses
#  $s0 File Descriptor
#  $s1 Input type (decimal or binary or hexadecimal)
#  $s2 Input value counter
#  $s3 Output type (Decimal or Binary or Hexadecimal)
#  $s4 Sign flag for negative values
#  $s5 Output value
#  $s6 Base of Input and Output type

Main:
UserInput:
        li $v0, 4                               # System call for printing string Head
        la $a0, Head                            # Load address of Head
        syscall                                 # Outputs string Head

        # Get the file name from the user
        li $v0, 4                               # System call for printing string prompt1
        la $a0, prompt1                         # Load address of prompt1
        syscall                                 # Outputs string promt1

        jal openFile                            # Calling procedure to remove the new line character from the end and open the file

iterateFile:
        #Initializing all counters to 0
        li $s1, 0                               # Initializing Input Type to 0
        li $s2, 0                               # Initializing Input Value to 0
        li $s3, 0                               # Initializing Output Type to 0
        li $s4, 0                               # Initializing Optional Sign to 0
        li $s5, 0                               # Initializing Output Value to 0

        # Reading Input Type and storing it in $s1
        move $a0, $s0                           # Temporarily copying file descriptor to $a0 for using in procedure
        jal nextByte                            # Calling nextByte function to read the next byte
        move $s1, $v1                           # Byte read in register $s1
        beq $v0, $0, end                        # If end of file is reached branch to end
        
        # Printing Input Type to the user
        li $v0, 11                              # System call to print a character
        move $a0, $s1                           # Loading address of the data to $a0
        syscall                                 # Print data
        li $v0, 4                               # System call to print a string
        la $a0, colonSpaceIP                    # Loading address of the data to $a0
        syscall                                 # Print the string colonSpaceIP
        
        # Reading Input Values and storing them in $s2
        move $a0, $s0                           # Temporarily copying file descriptor to $a0 for using in procedure
        jal nextByte                            # Calling nextByte function to read the next byte
        subi $s2, $v1, 48                       # Storing the read byte in $s2 after converting it to integer from ascii
        
        # Checking if the input length value is 1 or 2 characters long and adding it to the stored value
        jal nextByte                            # Calling nextByte function to read the next byte
        blt $v1, 0x30, saveOutputType           # If less than 0, jump to saveOutputType as it is not number but its the output type, so the length is 1 character long
        bgt $v1, 0x39, saveOutputType           # If more than 9, jump to saveOutputType as it is not number but its the output type, so the length is 1 character long
        subi $v1, $v1, 48                       # Converting read byte to integer from ascii
        mul $s2, $s2, 10                        # Multiply $s2 by 10 to create a 2 digit number as the lenght of value is 2 characters long
        add $s2, $s2, $v1                       # Add the newly read digit to the one stored in $s2

        # Read and Save the Output Type
findOutputType:
        jal nextByte                            # Calling nextByte function to read the next byte
saveOutputType:
        move $s3,$v1                            # Storing the read byte in $s3
        
        # Skip next two bytes as the input syntax would have ": " and it is assumed that the input syntax is properly followed during file creation
        jal nextByte                            # Calling nextByte function to read the next byte
        jal nextByte                            # Calling nextByte function to read the next byte

inputOperations:
# Series of Reading Input Values starts from here
# White spaces are ingnord while reading input value based on the input length calculated in previous step. Input Values is printed to the console as they are read.

        jal nextValue                           # Calling nextValue function to get the next non-white space value
        beq $v1, 0x2b, getFirstValue            # If it is positive, equal to '+' branch to getFirstValue
        beq $v1, 0x2d, setSignFlag              # Else, if it is negative, equal to '-' branch to setSignFlag
        j saveFirstValue                        # If the byte is neither '+' or '-', then the read byte must be a positive number branch to saveFirstValue

setSignFlag:
        li $s4, 1                               # If negative sign is found, the flag is set to 1

getFirstValue:
        jal nextValue                           # Calling nextValue function to get the next non-white space value

saveFirstValue:
        move $s5,$v1                            # Storing the read byte in $s5
        
        move $a1, $s1                           # Copying $s1 to $a0 to use the input type in doing next operation
        jal findBase                            # Calling findBase function to detemine the base of input value
        move $s6, $v0                           # Storing the base value to $s6
        
        move $a1, $s6                           # Copying base to $a1 to use the base value in doing the next operation
        move $a2, $s5                           # Copying output value to $a2 to use the ouput value in doing the next operation
        jal covertInteger                       # Calling covertInteger function to convert input value to integer
        move $s5, $v0                           # Copying the converted value to $s5
        
        subi $t3, $s2, 1                        # First character already read and converted so decrement by 1
        li $t2, 0                               # Initializing loop counter

storeAllValues:
        bge $t2, $t3, endAllValues              # If loop counter exceeds the digits length, branch and quit loop
        mul $s5, $s5, $s6                       # Multiplying by base to accomodate more digits for upcoming values
        jal nextValue                           # Calling nextValue function to get the next non-white space value
        
        move $a1, $s6                           # Copying base to $a1 to use the base value in doing the next operation
        move $a2, $v1                           # Copying $v1 to $a2 to use it for the next operation
        jal covertInteger                       # Calling covertInteger function to convert input value to integer
        add $s5, $s5, $v0                       # Adding the converted value to $s5
        
        addi $t2, $t2, 1                        # Incrementing the loop counter
        j storeAllValues                        # End of loop, branch to start of loop
endAllValues:

        # Reading till the end of line

endOfLine:
        jal nextByte                            # Calling nextByte function to read the next byte
        beq $v1, 0x0a, endEndOfLine             # If the read value is new line character, branch and quit loop to continue
        beq $v0, $0, endEndOfLine               # Else If null, that is, end of file, branch and quit loop to continue
        j endOfLine                             # End of loop, branch to start
endEndOfLine:

sign:        
        bne $s4, 1, endSign                     # If the sign flag is not 1, branch to endSign and continue
        sub $s5, $0, $s5                        # Else switch the sign of input value
endSign:


outputOperations:       
# Series of output operations start from here
        
        la $t2, opValue                         # Initializing $t2 to address of opValue variable
        li $t1, 0                               # Initializing counter $t1 to 0
clearValue:
        beq $t1, 40, endClearValue              # check if loop completed. If so jump to end
        sb $0, 0($t2)                           # Put $0 in current address
        addi $t2, $t2, 1                        # Increment the address
        addi $t1, $t1, 1                        # Increment the loop counter
        j clearValue                            # Jump back to start of loop
endClearValue:

        # Find the Output Type's numerical base
        move $a1, $s3                           # Copying output value to $a1 to use in the next procedure
        jal findBase                            # Calling findBase function to detemine the base of input value
        move $s6, $v0                           # Storing the base in $s6
        
        la $t2, opValue                         # Load address of opValue
        addi $t2, $t2, 39                       # add 39 to address as the string is filled from back

        move $t1, $s5                           # Storing the input value in $t1 to be used for computing
        li $t3, 0                               # Initializing $t3(Used for storing remainder of division)
        li $t4, 0                               # Initializing $t4(Used for storing counter based on base)
        li $t5, 0                               # Initializing $t4(Used for storing loop counter)
                 
        # If the number is negative, it is made positive for computing the output. Only modulus is need for Binary, Decimal and Hexa
        bge $t1, $0, binaries                   # If not negative, skip this portion
        sub $t1, $0, $t1                        # Subtract the value from 0 so that it becomes positive

        # For Hexa and Binary, the negetive sign is part of the number as it is represented in 2's complement. 
        # 2's Complement is taken to the positive part of the number
        beq $s6, 10, binaries                   # If output is in decimal, this segment is skipped
        subi $t1, $t1, 1                        # Subtract 1 from the input value for implementing 2's complement
        
        # Get the maximum length to which the loop must run
binaries:
        bne $s6, 2, decimals                    # If Output type is not binary, skip next line
        addi $t4, $t4, 32                       # For Binary, 32 digits are required so loop should happen 32 times
decimals:
        bne $s6, 10, hexas                      # If Output type is not decimal, skip next line
        addi $t4, $t4, 10                       # For Decimal, 10 digits are required for max value
hexas:                                
        bne $s6, 16, outputLoop                 # If Output type is not hex, skip next line
        addi $t4, $t4, 8                        # For Hex, 8 digits are required so loop should happen 8 times

outputLoop:
        bge $t5, $t4, endOutputLoop             # If counter reaches the required base counter, branch and quit loop
        bnez $t1, divideByBase                  # If the input value is fully operated upon, go to next line else skip it
        beq $s6, 10, endOutputLoop              # For decimal, leading 0's are not important, so branch and quit loop 
        
divideByBase:
        div $t1, $s6                            # Divide the value base to get quotient and remainder
        mfhi $t3                                # Storing remainder in $t3
        mflo $t1                                # Storing quotient back in $t1
        
        # Negate the remainder for 2s complement for binary and hex
        bge $s5, $0, hexaOutput                 # If the original Input value is positive, then skip
        beq $s6, 10, hexaOutput                 # If output is decimal, then skip
        # To get the 2's complement value, we need to subtract the value from (Base-1)
        sub $t3, $s6, $t3                       # Subtracting the remainder from the base of output type to get the complement
        subi $t3, $t3, 1                        # Subtracting 1 to complete the equation. And storing the complement in $t3
        
        # For hexa, we need to get the proper ascii symbol as it can have both numbers and letters
hexaOutput:
        bne $s6, 16, addNotHexa                 # If not hex, skip this segment
        ble $t3, 9, addNotHexa                  # If less than or equal to nine, same as normal digits so we can skip this segment
        addi $t3, $t3, 0x37                     # Else the values are aplhabets from a-f so we are adding 0x37 (9 lower than A in ascii as first 9 values are numerical digits)
        b endAddNotHexa                         # Conversion to digit symbols can be skipped. Directly store the obtained value

addNotHexa:
         addi $t3, $t3, 0x30                    # add '0' to the result
endAddNotHexa:
         
Delimiters: 
# Adding " " in the ouput of binary numbers and hexadecimal numbers and "," for decimals numbers
         beqz $t5 storeOutputValue              # If t5 is 0, the following computaion will work and Delimiters will be set at start of value so if 0, we skip the segment
setCommas:
        bne $s6, 10, setSpace                   # If not decimal, skip to binary & Hexa Delimiters as we need only space in them not commas
        li $t8, 3                               # Delimiters has to be set after every 3 digits
        div $t5, $t8                            # If the index is divisible by 3
        mfhi $t7                                # Storing the remainder from $hi to $t7
        bne $t7, 0, storeOutputValue            # If the counter is not a multiple of 3 skip this segment
        li $t8, 0x2c                            # Loading ',' into variable $t8
        sb $t8, 0($t2)                          # Storing Comma Delimiter into current address of output value
        subi $t2, $t2, 1                        # Decrementing the address counter

setSpace:
        li $t8, 4                               # Spaces has to be set after every 4 digits of binary or hexa values
        div $t5, $t8                            # If the index is divisible by 4
        mfhi $t7                                # Storing the remainder from $hi to $t7
        bne $t7, 0, storeOutputValue            # If counter is not a multiple of 4 skip this segment
        li $t8, 0x20                            # load ' ' into variable $t8
        sb $t8, 0($t2)                          # Storing Space Delimiter into current address of output value
        subi $t2, $t2, 1                        # Decrementing the address counter
        
storeOutputValue:
        sb $t3, 0($t2)                          # Storing the output digit into current address of output value
        subi $t2, $t2, 1                        # Decrementing the address counter
        addi $t5, $t5, 1                        # Incrementing the loop counter
        j outputLoop                            # End of loop branch back to iterate
endOutputLoop:

        # Set minus '-' symbol only for decimal numbers if the input number is negative, binary and hexa will be in 2's complement form
        bne $s6, 10, printOutput                # If not decimal, branch and skip this portion
        bge $s5, 0, printOutput                 # If original input value is not negetive, skip this portion, if flag greater than 0
        li $t3, '-'                             # Loading minus '-' into variable $t3
        sb $t3, 0($t2)                          # Storing negative symbol in the current address of output value
        subi $t2, $t2, 1                        # Decrementing the address counter
        
printOutput:
        li $v0, 4                               # System call for printing string 
        la $a0, semiColonSpaceOP                # Load address of constant semiColonSpaceOP to $a0 to print
        syscall                                 # Print string

        li $v0, 11                              # System call for printing character
        move $a0, $s3                           # Load address of output type to $a0 to print
        syscall                                 # Print output type

        li $v0, 4                               # System call for printing string 
        la $a0, colonSpaceIP                    # Load address of constant colonSpaceIP to $a0 to print
        syscall                                 # Print string

        addi $t2, $t2, 1                        # Incrementing address of output value so that it points to first charecter
        move $a0, $t2                           # Load address of output value to $a0 to print
        syscall                                 # Print output value
        la $a0, newlineChar                     # Load address of constant newlineChar to $a0 to print
        syscall                                 # Print new line
        
        j iterateFile                           # End of loop, brach to iterate loop
        
end:   

# Close the file as part of cleaning up
        jal closeFile                           # Calling nextByte function to read the next byte 

        li $v0, 4                               # System call for printing string Foot
        la $a0, Foot                            # Load address of Foot String
        syscall                                 # Outputs string Foot 

        li $v0, 10                              # Termination
        syscall

#Procedure: convertInteger
#Modification History: 
# a. Procedure created by Author on 11/13/2021
#Description: Procedure to convert the input value into integer (decimal) value based on base
#Arguments:
#  $v0 Output value
#  $a1 Input parameter, base
#  $a2 Input parameter, value as characters

covertInteger:
        bne $a1, 16, convertNumbers             # If base is not hexadecimal, then we need to convert only numbers, branch to convertNumbers
        ble $a2, '9', convertNumbers            # Else if the input value is number branch to convertNumbers
        
        blt $a2, 'a', convertCapital            # If value is not a small letter, branch to convert capital letters
        sub $v0, $a2, 'a'                       # Converting alphabet to integer by subtracting the value of 'a' in ascii
        addi $v0, $v0, 10                       # Adding 10 for numerical values in hexadecimal input
        j endConvert                            # Branch to end of function
        
convertCapital:
        sub $v0, $a2, 'A'                       # Converting alphabet to integer by subtracting the value of 'A' in ascii
        addi $v0, $v0, 10                       # Adding 10 for numerical values in hexadecimal input
        j endConvert                            # Branch to end of function
        
convertNumbers:
        sub $v0, $a2, '0'                       # Converting number symbol to integer by subtracting the value of 0 in ascii

endConvert:
jr $ra                                          # Return to primary function

#Procedure: openFile
#Modification History: 
# a. Procedure created by Author on 11/11/2021, based on suggestions from Professor Dr. Richard A. Goodrum, Ph.D for buffer and file name length
#Description: Procedure to remove the new line character from the end of the file name and open the file
#Arguments:
#  $v0 For system calls
#  $a0 Starting addresses
#  $a1 End of file name
#  $t0 Comparison
#  $s0 Saving file descriptor

openFile:
        li $v0, 8                               # System call for reading string from user
        la $a0, fileIn                          # Load address of fileIn, variable to store the input to
        la $a1, fileInLength                    # Defining the maximum length of the input text
        lw $a1, 0($a1)                          # Length of 128 bytes for the file name length
        syscall                                 # Reading the input

        add $a1, $a0, $a1                       # End of loop set to file name plus fileInLength
iterateName:
        beq $a0, $a1, removed                   # If the file name is completely iterated to its entire length then branch to removed for open operation
        lbu $t0, 0($a0)                         # Load charecter at current address
        beq $t0, 0x0a, skip                     # If the current character is new line branch to skip
        addi $a0, $a0, 1                        # Increment the counter by 1
        j iterateName                           # End of loop, loop until branched out

skip:
        sb $0, 0($a0)                           # Place 0 instead of new line character at the end of file name

removed:
        la $a0, fileIn                          # Load address of fileIn
        li $a1, 0                               # Opening file in read mode
        li $a2, 0                               # Mode ignored
        li $v0, 13                              # System call for opening file
        syscall                                 # Open file

        move $s0, $v0                           # Save the file descriptor

jr $ra                                          # Return to the primary function

#Procedures: closeFile
#Modification History: 
# a. Procedure created by Author on 11/11/2021 
#Description: Procedure to close the file

closeFile:                                      # Procedure to close the file
        li   $v0, 16                            # System call for close file
        move $a0, $s0                           # File descriptor to close
        syscall                                 # Close the file

jr $ra                                          # Return to primary function

#Procedure: findBase
#Modification History: 
# a. Procedure created by Author on 11/13/2021
#Description: Procedure to find the base of input value based on the character retrieved
#Arguments:
#  $a1 Input parameter that has the character data of the input's base
#  $v0 Output as corresponding integer types, 2 for b, 10 for d and 16 for h

findBase:
        beq $a1, 0x62, binary                   # If the base is 'b' branch to binary
        beq $a1, 0x42, binary                   # or If the base is 'B' branch to binary
        beq $a1, 0x64, decimal                  # If the base is 'd' branch to decimal
        beq $a1, 0x44, decimal                  # or If the base is 'D' branch to decimal
        beq $a1, 0x68, hexa                     # If the base is 'h' branch to hexa
        beq $a1, 0x48, hexa                     # or If the base is 'H' branch to hexa
        
binary:
        li $v0, 2                               # Loading base as 2 to $v0
        j endBase                               # Branch to end of function
        
decimal:
        li $v0, 10                              # Loading base as 10 to $v0
        j endBase                               # Branch to end of function
        
hexa:
        li $v0, 16                              # Loading base as 16 to $v0
        
endBase:
jr $ra                                          # Return to primary function
        
#Procedure: nextValue
#Modification History: 
# a. Procedure created by Author on 11/13/2021, based on suggestions from Professor Dr. Richard A. Goodrum, Ph.D. to ignore white spaces
#Description: Procedure to get the next value in input by skipping white spaces using stack operations
#Arguments:
#  $v0 Number of integer bytes read for output
#  $v1 Number of character bytes read
#  $a0 File Descriptor input parameter
#  $t0, $t1 Temporary variables
 
nextValue:
        addi $sp $sp -4                         # Removing space in stack pointer to store new integer value
        sw $ra -4($sp)                          # $ra being stored in stack
        
nextValidValue:
        jal nextByte                            # Calling nextByte function to read the next byte
        
        move $t0, $a0                           # Copying $a0 to tempory register $t0
        move $t1, $v0                           # Copying $v0 to tempory register $t1
        move $a0, $v1                           # Loading value read to $a0 for printing
        li $v0, 11                              # System call to print character on the console
        syscall                                 # Print Character

        move $a0, $t0                           # Copy the value back to $a0 from $t0
        move $v0, $t1                           # Copy the value back to $v0 from $t1

        beq $v1, 0x20, nextValidValue           # If Space is found, branch to nextValidValue to skip it
        beq $v1, 0x09, nextValidValue           # If Tab is found, branch to nextValidValue to skip it
        beq $v1, 0x0b, nextValidValue           # If Vertical tab is found, branch to nextValidValue to skip it
        beq $v1, 0x0c, nextValidValue           # If Form feed is found, branch to nextValidValue to skip it
        beq $v1, 0x0a, nextValidValue           # If New line is found, branch to nextValidValue to skip it
        beq $v1, 0x0d, nextValidValue           # If Carriage return is found, branch to nextValidValue to skip it
        
        lw $ra -4($sp)                          # $ra being loaded from the stack
        addi $sp $sp 4                          # Adding space back to the stack pointer

jr $ra                                          # Return to the primary function

#Procedure: nextByte
#Modification History: 
# a. Procedure created by Author on 11/13/2021, based on suggestions from Professor Dr. Richard A. Goodrum, Ph.D. to read content one byte at a time
#Description: Procedure to read the content of the file one byte at a time
#Arguments:
#  $v0 For system calls
#  $a1 Storing content of the file
#  $a2 Storing length to be read
#  $v1 Storing the read content

nextByte:
        la $a1, fileCon                         # Using fileCon to store the content of read from the file
        la $a2, conLength                       # Length of content to be read
        lb $a2, 0($a2)                          # Reading 1 byte at a time
        li $v0, 14                              # System call to do read operation
        syscall                                 # Read content
        lbu $v1, 0($a1)                         # Storing the content read into $v1

jr $ra                                          # Return to primary function