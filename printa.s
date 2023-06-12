.globl main


.section .rodata
charA1:
  .ascii "a"
charA2:
  .ascii "aa"
charA4:
  .ascii "aaaa"
charA8:
.ascii "aaaaaaaa"
fmt:
 .string "%ld"
fmt_out:
 .string "%s"
fmt_outp:
 .string "%p\n"

.section .bss
size:
  .space 8
bufferpointer:
  .space 8

.text
main:
  pushq %rbp
  movq %rsp, %rbp
  
 restart: 
  movq stdin, %rdi
  movq $fmt, %rsi
  movq $size, %rdx
  xor %eax, %eax
  call fscanf #save the size

  movq size, %rdi
  call allocate
  movq %rax, bufferpointer

  movq stdout, %rdi
  movq $fmt_outp, %rsi
  movq bufferpointer, %rdx #address returned from allocate
  xor %eax, %eax
  call fprintf

 
  movq size, %rax
  subq $1, %rax #make room for null
  movq %rax, size # copy back
  xor %edx, %edx #zero the higher part of the dividend

loop8:
  movq $8, %rdi
  divq %rdi
  cmpq $0, %rax
  jnz quadM
  
  movq size, %rax
  xor %edx, %edx #zero the higher part of the dividend
loop4:
  movq $4, %rdi
  divq %rdi
  cmpq $0, %rax
  jnz longM

  xor %edx, %edx #zero the higher part of the dividend
  movq size, %rax
loop2:
  movq $2, %rdi
  divq %rdi
  cmpq $0, %rax
  jnz wordM
  
  movq size, %rax
  cmpq $0, %rdx
  jz continue

  movq bufferpointer, %rax
  movb charA1, %cl
  movb %cl, (%rax)
  
continue:
  movq stdout, %rdi
  movq $fmt_out, %rsi
  movq bufferpointer, %rdx #address returned from allocate
  xor %eax, %eax
  call fprintf

  movq bufferpointer, %rdi
  call deallocate
  jmp restart

  leave
  ret


quadM:
  movq %rdx, %r8
  movq %rax, %rdx
  movq bufferpointer, %rax
  addq %r8, %rax
  movq charA8, %rcx
  movq %rcx, -8(%rax,%rdx,8)
  subq $8, size
  movq size, %rax
  xor %edx, %edx
  jmp loop8

longM:
  movq %rdx, %r8
  movq %rax, %rdx
  movq bufferpointer, %rax
  addq %r8, %rax
  movl charA4, %ecx
  movl %ecx, -4(%rax,%rdx,4)
  subq $4, size
  movq size, %rax
  xor %edx, %edx
  jmp loop4

wordM:
  movq %rdx, %r8
  movq %rax, %rdx
  movq bufferpointer, %rax
  addq %r8, %rax
  movw charA2, %cx
  movw %cx, -2(%rax,%rdx,2)
  subq $2, size
  movq size, %rax
  xor %edx, %edx
  jmp loop2




