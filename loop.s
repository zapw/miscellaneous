.globl _start
.section .data
myvalue:
    .quad 9999999999

.section .text

_start:
movq myvalue, %rcx # comments
movq $0, %rdi
loop:
#loopq loop
decq %rcx
#cmpq $0, %rcx
jne loop
movq $60, %rax
syscall
