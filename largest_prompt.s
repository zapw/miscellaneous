#print the index of the element equal to findthis
.globl main
.section .data
# How many data elements we have
findthis: # not being used
 .quad 33
numberofnumbers: # not being used
 .quad 7
# The data elements themselves
mynumbers: #not being used
 .quad 5, 20, 33, 80, 52, 90, 4
### This program will find the largest value in the array
 askquestion:
 .ascii "enter the stupid 7 numbers\n\0"
 askquestion_2:
 .ascii "ok what number do you want to find enter it\n\0"
 askquestion_fmt_2:
  .ascii "%ld\0"
 askquestion_fmt:
  .ascii "%ld %ld %ld %ld %ld %ld %ld\0"
 thenumberis:
  .ascii "the index of the number is %ld\n\0"
 numbernotfound:
  .ascii "number not found nigga\n\0"
 continue_fmt:
  .ascii " %c\0"
 continuey:
  .ascii "do you want to continue??? y/n\n\0"
.section .text
main:
pushq %rbp
movq %rsp, %rbp
subq $96, %rsp #reserve for 7 parameters of them: 4 passed to registers, 3 saved on the stack and 3*8 for padding to 16 byte boundary( the 3 highest addresses)

restart:
movq stdout, %rdi
movq $askquestion, %rsi
xor %eax, %eax
call fprintf
xor %eax, %eax
  movq stdin, %rdi
  movq $askquestion_fmt, %rsi
  leaq -24(%rbp), %rdx
  leaq -32(%rbp), %rcx
  leaq -40(%rbp), %r8
  leaq -48(%rbp), %r9
  
  leaq -72(%rbp), %rax
  movq %rax, -80(%rbp)

  leaq -64(%rbp), %rax
  movq %rax, -88(%rbp)
  
  leaq -56(%rbp), %rax
  movq %rax, -96(%rbp)
  xor %eax, %eax

call fscanf
movq %rax, %r12 # Put the number of elements read in %r12 copy this to %rcx
movq stdout, %rdi
movq $askquestion_2, %rsi
xor %eax, %eax
call fprintf
movq stdin, %rdi
movq $askquestion_fmt_2, %rsi
subq $16, %rsp # 8bytes for saving the value to search , 8bytes for padding
leaq -112(%rbp), %rdx
xor %eax, %eax
call fscanf

 movq %r12, %rcx # should be 7
 movq %r12, %r13 # should be 7
 movq -112(%rbp), %rdi # want number to search for 
 cmp $0, %rcx # is number of lements 0
 je endloop_notfound
myloop:
 movq -80(%rbp,%rcx,8), %rax
 cmp %rdi, %rax
 je endloop
 subq $1, %rcx
 jnz myloop
 jmp endloop_notfound
endloop:
  subq %rcx, %r13
  #movq %r13, %rax # move to %rax before exiting - this will be passed to the return value after exit syscall
  movq stdout, %rdi
  movq $thenumberis, %rsi
  movq %r13, %rdx
  xor %eax, %eax
  call fprintf
  xor %eax, %eax

  jmp continue_qst

endloop_notfound:
  movq stdout, %rdi
  movq $numbernotfound, %rsi
  xor %eax, %eax
  call fprintf
  xor %eax, %eax

  jmp continue_qst

continue_qst:
  movq stdout, %rdi
  movq $continuey, %rsi
  xor %eax, %eax
  call fprintf

  movq stdin, %rdi
  movq $continue_fmt, %rsi
  leaq -104(%rbp), %rdx
  xor %eax, %eax
  call fscanf
  
  movb -104(%rbp), %al
  addq $16, %rsp
  cmpb $'y', %al
  je restart
  jmp leavethis

leavethis:
  leave
  ret
