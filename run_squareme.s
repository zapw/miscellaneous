.global main
.section .data
value:
 .quad 6
output:
 .ascii "The square of %ld is %ld\n\0"
.section .text
.type main, @function
.type squareme, @function
main:
 pushq %rbp
 movq %rsp, %rbp

 movq value(%rip), %rdi
 call squareme
 movq stdout(%rip), %rdi
 leaq output(%rip), %rsi
 movq value(%rip), %rdx
 movq %rax, %rcx
 xor %eax, %eax
 call fprintf
 leave
 ret

