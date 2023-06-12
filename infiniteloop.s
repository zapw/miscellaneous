.globl _start

foobar:
 movq $2, %rax

#.section .text
cheese:
 movq $3, %rax

_start:
 movq $60, %rax

another_location:
 movq $8, %rdi
 jmp foobar
 # This never gets executed
 syscall
