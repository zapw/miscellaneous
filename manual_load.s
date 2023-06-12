.globl main
.section .data
filename:
 .ascii "./libmymath.so\0"
functionname:
 .ascii "printstuff\0"
.section .text
main:
 pushq %rbp
 movq %rsp, %rbp
 leaq filename(%rip), %rdi
 movq $1, %rsi # the flag for lazy-loading
 call dlopen
 movq %rax, %rdi
 leaq functionname(%rip), %rsi
 call dlsym
 call *%rax
 leave
 ret

