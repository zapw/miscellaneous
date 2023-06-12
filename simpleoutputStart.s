.globl _start
 ### Exit 
.section .data
mynum:
 .quad 20 
mystring:
 .ascii "Hello there!\n"
 .ascii "Humus Chips Salad\n"
mystring_end:
mystringne:
 .ascii "Hello there!\n"
 .ascii "Hello there you had humuus today!\n"
mystring_endne:
.equ mystring_length, mystring_end - mystring
.equ mystring_lengthne, mystring_endne - mystringne
.section .text
 ### Display the string
 # System call number
 .section .text
 _start:
  movq $mystring, %rdi
  movq $mystring_length, %rsi
  movq $mystringne, %rdx
  movq $mystring_lengthne, %rcx
  movq mynum, %r8

  
  call simploutput
  movq $0x3c, %rax
  movq $0, %rdi
  syscall

