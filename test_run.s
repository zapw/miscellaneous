.globl main

.text
main:
  movq $4, %rdi
  movq $4, %rsi
  call hummus
  ret

