.globl _start
.section .text
_start:
 # First parameter is -5
 movq $-5, %rdi
 # Call the function
 call abs
 # Result is in %rax, move to %rdi for the exit syscall
 movq %rax, %rdi
 movq $60, %rax
 syscall

