.global main
.section .data
value:
 .quad 6
output:
 .ascii "The square of %d is %d\n\0"
.section .text
.type main, @function
.type squareme, @function
main:
 pushq %rbp
 movq %rsp, %rbp

 movq value(%rip), %rdi
 call squareme@plt
 movq stdout@GOTPCREL(%rip), %rdi
 movq (%rdi), %rdi
 leaq output(%rip), %rsi
 movq value(%rip), %rdx
 movq %rax, %rcx
 xor %eax, %eax
 call fprintf@plt
 leave
 ret

