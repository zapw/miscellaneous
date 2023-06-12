.globl _start
.section .data
humus:
 .quad 33
.section .text
_start:

 # Perform various arithmetic functions
 movq $3, %rdi
# movq %rdi, %rax
 addq $2147483647, %rax
 mulq %rdi
 movq $2, %rdi
 addq %rdi, %rax
 movq $4, %rdi
 mulq %rdi
 movq $0, %rcx
 movq $0, %rbx
 leaq humus(%rcx,%rbx,1), %rax
 movq (%rax), %rdi
 movq $60, %rax
# Set the exit system call number
 # Perform the system call
 syscall
