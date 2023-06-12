.globl main

.type factorial, @function
.section .rodata
fmt:
 .string "humus chips %lld\n"

.text
main:
  pushq %rbp
  movq %rsp, %rbp

  movq $5, %rdi
  call factorial@plt

  movq stdout@GOTPCREL(%rip), %rdi
  movq (%rdi), %rdi
  leaq fmt(%rip), %rsi
  movq %rax, %rdx
  xor %eax, %eax
  
  call fprintf@plt
  leave
  ret

