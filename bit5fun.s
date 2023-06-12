.globl bit5fun

.type bit5fun, @function

.section .text
bit5fun:
    pushq %rbp
    movq %rsp, %rbp
    subq $32, %rsp
    movq %rdi, -8(%rbp)
    movq %rsi, -16(%rbp)
    movq %rdx, -24(%rbp)
    movq %rbx, -32(%rbp)
    
    #first check all 1s
    movq -8(%rbp), %rax
    andq -16(%rbp), %rax
    andq -24(%rbp), %rax

    #now check all 0s
    movq -8(%rbp), %rbx
    movq -16(%rbp), %rcx
    movq -24(%rbp), %rdi
    
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
    movq %rdi, %rax
    movq -32(%rbp), %rbx
    leave
    ret
    
#and and and to get all 1 bits in common
#not! fst arg, not scnd arg ( And both args) 
#not! 3rd arg ( and ) to get all 0 bits in common

#now orq between two results

#then shuffle between instructions counting 0s and 1s
#you want sum of all the 1s