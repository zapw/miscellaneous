.globl _start




.section .text


_start:
 movq $-1, %rdi
 movl $-1, %edi
 movq $60, %rax
 syscall

