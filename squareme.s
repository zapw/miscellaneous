.globl squareme
.section .text
.type squareme, @function
squareme:
 pushq %rbp
 movq %rsp, %rbp
 movq %rdi, %rax
 imulq %rdi, %rax
 leave
 ret

