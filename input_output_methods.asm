.data
size_prompt: .asciiz "Enter the size of the array: "
numbers_prompt: .asciiz "Please enter the numbers you wish to sort: \n"
space : .asciiz" "
error: .asciiz "Array size can't be zero enter a reasonable array size \n"
.text
main:
    # Display size prompt
    li $v0, 4
    la $a0, size_prompt
    syscall

    # Read the size of the array
    li $v0, 5
    syscall
    #handling the improper array sizes 
    slt $t4,$zero,$v0 #if $zero<$v0---> $t4=1
    beq $t4,$zero,error_message #if $t4 !=0 branch to error message
    move $t1, $v0  # $t1 = size of the array
     

    # Allocate memory for the array
    li $v0, 9
    move $a0, $t1  # Allocate space for $t1 integers
    li $v1, 4      # Each integer occupies 4 bytes
    syscall
    move $t0, $v0  # $t0 = base address of the array
    move $t8,$t0 

    # Display numbers prompt
    li $v0, 4
    la $a0, numbers_prompt
    syscall

    # Input loop: Read numbers from the user and store them in the array
    move $t2, $zero  # $t2 = counter initialized to zero for input loop
input_loop:
    li $v0, 6
    syscall
    s.s  $f0, 0($t0)    # Store the input number into memory
    addi $t0, $t0, 4  # Move to the next memory location
    addi $t2, $t2, 1  # Increment the counter for input loop
    bne $t2, $t1, input_loop  # Repeat input loop until counter equals size

    # Output loop: Print the numbers stored in the array
    li $t2, 0      # Reset $t2 to zero for output loop
output_loop:
    bge $t2, $t1, exit  # Exit if counter is equal to size

    l.s $f12,($t8)      # Load the number from memory
    li $v0, 2           # syscall code for printing float
    syscall 		#PRINT THE NUMBER 
    
    li $v0,4
    la $a0,space
    syscall 
                 
    addi $t8, $t8, 4 # Move to the next memory location
    addi $t2, $t2, 1      # Increment the counter for output loop
    j output_loop         # Repeat output loop

exit:
    li $v0, 10
    syscall

error_message:
	#displaying the error message and loop back into the main function to take a proper input 
	li $v0,4 
	la $a0,error
	syscall
	j main
