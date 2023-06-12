.globl main
 ### Exit 
.section .rodata
 format:
  .ascii "%s\0"

format_num:
  .ascii "%ld\0"

newline:
  .ascii "\n\0"

filename_read:
  .ascii "readin.txt\0"
openmode:
  .ascii "r\0"
#mynum:
#  .quad 20

.equ inputfile, -544
.equ mynum, -536
.equ current_char_count, -528
.equ current_char_count2, -520
 .section .text
main:
  pushq %rbp
  movq %rsp, %rbp

  subq $544, %rsp
  
  #open file
  movq $filename_read, %rdi
  movq $openmode, %rsi
  call fopen
  
  movq %rax, inputfile(%rbp) #save input file descriptor

  #movq stdin, %rdi
  movq inputfile(%rbp), %rdi
  movq $format, %rsi
  leaq -512(%rbp), %rdx
  xor %eax, %eax
  call fscanf

  movq stdout, %rdi
  leaq -512(%rbp), %rsi
  xor %eax, %eax
  call fprintf
  
  movq %rax, current_char_count(%rbp) #save count of characters on the stack
  
  movq stdout, %rdi
  movq $newline, %rsi 
  xor %eax, %eax
  call fprintf #print newline
  
  movq current_char_count(%rbp), %rax
  movb newline, %dl
  movb %dl, -512(%rbp,%rax) #append new line \n  to end of string count returned in %rax

  addq $1, current_char_count(%rbp) #add 1 more chars to the counter (for newline)
  movq current_char_count(%rbp), %r12

  movq inputfile(%rbp), %rdi
  #movq stdin, %rdi
  movq $format, %rsi
  leaq -512(%rbp,%r12), %rdx #append %r12 the char counter so next string will start at end of the last
  xor %eax, %eax
  call fscanf

  movq stdout, %rdi
  leaq -512(%rbp,%r12), %rsi
  xor %eax, %eax
  call fprintf
  movq %rax, current_char_count2(%rbp) #save count of characters on the stack

  movq stdout, %rdi
  movq $newline, %rsi 
  xor %eax, %eax
  call fprintf #print newline

  movq current_char_count2(%rbp), %rax
  addq %r12, %rax
  
  movb newline, %dl
  movb %dl, -512(%rbp,%rax) #append new line \n  to end of string 

  addq $1, current_char_count2(%rbp) #add 1 more chars to the counter (for newline)

  movq inputfile(%rbp), %rdi
  #movq stdin, %rdi
  movq $format_num, %rsi
  leaq mynum(%rbp), %rdx # how many times to print
  xor %eax, %eax
  call fscanf

  leaq -512(%rbp), %rdi
  movq current_char_count(%rbp), %rsi
  leaq -512(%rbp,%r12), %rdx
  movq current_char_count2(%rbp), %rcx
  movq mynum(%rbp), %r8
  xor %eax, %eax

  call simploutput
  
  movq inputfile(%rbp), %rdi
  call fclose
  
  xor %eax, %eax

  leave
  ret

