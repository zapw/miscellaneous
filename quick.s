.globl _start


.text

_start:
  movq $1, %rdi

  movq $66, %rax
  movq $55, %rdx
  cmpq %rax, %rdx
  ja next
  movq $2, %rdi
next:
  movq $60, %rax
  syscall


