.globl main

.section .data
output:
  .ascii "hello\n\0"
.section .text
main:
  pushq %rbp
  movq %rsp, %rbp

  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq output(%rip), %rsi
  xor %eax, %eax
  call *fprintf@GOTPCREL(%rip)
  movq $0, %rax
  leave
  ret

