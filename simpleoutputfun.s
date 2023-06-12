.globl simploutput

.section .rodata
filename:
  .string "somefile.txt"

.equ STR1, -8
.equ STR1_L, -16
.equ STR2, -24
.equ STR2_L, -32
.equ ITR, -40

.type simploutput, @function
.section .text
simploutput:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp
  movq %rdi, STR1(%rbp)
  movq %rsi, STR1_L(%rbp)
  movq %rdx, STR2(%rbp)
  movq %rcx, STR2_L(%rbp)
  movq %r8,  ITR(%rbp)

  movq $2, %rax # 2 is for open syscall /usr/include/x86_64-linux-gnu/asm/unistd_64.h
  movq $filename, %rdi
  movq $1, %rsi # 0 is readonly #1 is for write
  orq $85, %rsi # 85 is for create file if not exist
  movq $0600, %rdx # for read/write mode rw
  syscall

  movq %rax, -56(%rbp) #save file descriptor

  loop:
  xor %rdx, %rdx
  movq ITR(%rbp), %rax
  movq $2, %rbx
  divq %rbx
  cmpq $0, %rdx
  jne uneven
  #movq $1, %rax
  movq $1, %rax # write data
  # file descriptor
  movq -56(%rbp), %rdi
  # pointer to the data
  movq STR1(%rbp), %rsi
  # length of the data
  movq STR1_L(%rbp), %rdx
  
  syscall
  movq $1, %rax
  syscall
  subq $1, ITR(%rbp)
  jnz loop
  leave
  ret
uneven:
  movq $1, %rax
  # File descriptor
  movq -56(%rbp), %rdi
  movq STR2(%rbp), %rsi
  # length of the data
  movq STR2_L(%rbp), %rdx
  syscall
  movq $1, %rax
  syscall
  subq $1, ITR(%rbp)
  jnz loop
  
  movq -56(%rbp), %rdi #move file descriptor to %rdi
  movq $3, %rax # 3 is for close syscall
  syscall
  
  leave
  ret
