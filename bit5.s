.globl _start

.section .data
  
.equ bit1, 0b110000010100101110111110
.equ bit2, 0b010101010101000011110111
.equ bit3, 0b010100101001110101111000


.section .text
_start:
    #first check all 1s
    movq $bit1, %rax
    andq $bit2, %rax
    andq $bit3, %rax

    #now check all 0s
    movq $bit1, %rbx
    movq $bit2, %rcx
    movq $bit3, %rdi
    
    notq %rbx
    notq %rcx
    notq %rdi
    
    andq %rcx, %rbx
    andq %rdi, %rbx
    
    orq %rbx, %rax

    xorq %rdi, %rdi         # clear the counter register

count_loop:
    bsfq %rax, %rcx         # find the position of the lowest-order 1 bit in RAX
    jz end_count_loop       # if there are no more set bits, jump to the end

    addq $1, %rdi           # increment the counter
    addq $1, %rcx

    shrq %rcx, %rax         # clear the lowest-order 1 bit

    jmp count_loop          # jump back to the beginning of the loop

end_count_loop:
    # RCX now contains the number of bits set in the value
    
    movq $60, %rax
    syscall
    


#and and and to get all 1 bits in common
#not! fst arg, not scnd arg ( And both args) 
#not! 3rd arg ( and ) to get all 0 bits in common

#now orq between two results

#then shuffle between instructions counting 0s and 1s
#you want sum of all the 1s
