.globl _start

.section .data
  .quad 324234
olaola:
  .quad 13123123123
  .quad 131231231231


.section .text
_start:
  movq $3, %rax
  movq $5, %rbx
  movq $333, %rdi
  movq $33, %rsi
