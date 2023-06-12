.globl _start


.section .data
number1:
  .quad 0xc000000000000000, 212, 233, 12334, 1232
number2:
  .quad 0x4000000000000000, 999, 333, 1212, 1222
res12:
  .quad 0, 0, 0, 0, 0

.section .text
_start:
  movq $0, %rdx
  movq $0, %rbx
  movq $0, %rax
  movq $5, %rdi
loop:
  movq number1(,%rbx,8), %rax
  addq %rcx, %rax
  addq number2(,%rbx,8), %rax
  movq %rax, res12(,%rbx,8)
  movq $0, %rcx
  adcq $0, %rcx
  addq $1, %rbx
  decq %rdi
  jnz loop

  movq res12+32, %rax
  movq res12+24, %rax
  movq res12+16, %rax
  movq res12+8, %rax
  movq res12, %rax

  movq %rcx, %rdi
  movq $60, %rax
  syscall
  