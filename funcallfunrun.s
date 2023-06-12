.globl _start


.section .text

_start:
  movq $7, %rdi
  call funcallfun
  movq %rax, %rdi
  movq $60, %rax
  syscall
