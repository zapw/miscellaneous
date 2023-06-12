.globl main

.type somefun, @function

.text

main:
  movq $50, %r12
  movq $2, %rdi
loop1:
  call somefun
  subq $1, %r12
  jne loop1
  ret

 somefun:
  movq %rdi, %rax
  ret

 