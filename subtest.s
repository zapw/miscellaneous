.globl _start


.section .text


_start:
  movq $5, %rax
  subq $6, %rax
  movq %rax, %rdi
  movq $60, %rax
  syscall

