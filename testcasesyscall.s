.globl _start







.section .data
filename:
  .ascii "somefile.txt\0"

.section .text
_start:
  movq $2, %rax # 2 is for open syscall /usr/include/x86_64-linux-gnu/asm/unistd_64.h
  movq $filename, %rdi
  movq $1, %rsi # 0 is readonly #1 is for write
  orq $85, %rsi # 85 is for create file if not exist
  syscall

  movq %rax, %rdi #move file descriptor to %rdi
  movq $3, %rax # 3 is for close syscall
  syscall
  
  movq $60, %rax
  movq $0, %rdi
  syscall


