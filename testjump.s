.globl _start

.data
jmpto:
  .quad 0

.section .text
somefun:
  movq $2, %rdi
  leaq (%rbx), %rcx
  movq %rcx, jmpto
  jmp *jmpto

_start:
  movq $3, %rdi
  movq $continue, %rbx
  jmp somefun
continue:
  movq $5, %rdi
  movq $continue2, %rbx
  jmp somefun
continue2:

  movq $60, %rax
  syscall

