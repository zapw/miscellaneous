.globl _start



.section .text

_start:
  movq $5, %rax
  movq $6, %rax
.balign 128
  movq $7, %rax
  movq $60, %rax
  movq $0, %rdi
  syscall 

