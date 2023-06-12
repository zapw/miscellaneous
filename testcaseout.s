.globl main

.section .data
 format:
  .ascii "%s\0"

newline:
  .ascii "\n\0"

.section .text

main:
  pushq %rbp
  movq %rsp, %rbp
  subq $512, %rsp
  movq stdin, %rdi
  movq $format, %rsi
  leaq -512(%rbp), %rdx
  xor %eax, %eax
  call fscanf
  movq stdout, %rdi
  leaq -512(%rbp), %rsi
  xor %eax, %eax
  call fprintf
  
  subq $16, %rsp
  movq %rax, -528(%rbp) #save count of characters on the stack
  
  movq stdout, %rdi
  movq $newline, %rsi 
  xor %eax, %eax
  call fprintf #print newline
  
  popq %rax #pop saved characters  from stack and save it to %rax
  addq $8, %rsp

  movw newline, %cx
  movw %cx, -512(%rbp,%rax) #append new line \n\0  to end of string count returned in %rax
  movq stdout, %rdi
  leaq -512(%rbp), %rsi
  xor %eax, %eax
  call fprintf

  leave
  ret
