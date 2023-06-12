.globl _start



.text
_start:

  movq $5504, %rdi
  call allocate
  movq $8000, %rdi
  call allocate
#  movq %rax, %rdi
#  call deallocate
  movq $2640, %rdi
  call allocate
  
  movq $0, %rdi
  movq $60, %rax
  syscall

  

#Rdi:
#  .space 8
#Rsi:
#  .space 8
#Rdx:
#  .space 8
#Rax:
#  .space 8
#  movq %rdi, Rdi
#  movq %rsi, Rsi
#  movq %rdx, Rdx
#  movq %rax, Rax

#  movq stdout, %rdi
#  movq $fmt_outp, %rsi
#  movq SIZE_STACK(%rbp), %rdx #address returned from allocate
#  xor %eax, %eax
#  call fprintf
#  movq stdout, %rdi
#  movq $fmt_outp, %rsi
#  movq Rdx, %rdx #address returned from allocate
#  xor %eax, %eax
#  call fprintf

#  movq Rdi, %rdi
#  movq Rsi, %rsi
#  movq Rdx, %rdx
#  movq Rax, %rax
