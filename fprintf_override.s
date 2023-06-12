.globl fprintf
.section .data
mytext:
 .ascii "Haha! I intercepted you!\n"
mytextend:
.section .text
fprintf:
 movq $1, %rax
 movq $1, %rdi
 leaq mytext(%rip), %rsi
 movq $(mytextend - mytext), %rdx
 syscall
 ret

