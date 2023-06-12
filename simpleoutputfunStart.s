.globl simploutput

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
  subq $48, %rsp
  movq %rdi, STR1(%rbp)
  movq %rsi, STR1_L(%rbp)
  movq %rdx, STR2(%rbp)
  movq %rcx, STR2_L(%rbp)
  movq %r8,  ITR(%rbp)
loop:
  xor %rdx, %rdx
  movq ITR(%rbp), %rax
  movq $2, %rbx
  divq %rbx
  cmpq $0, %rdx
  jne uneven
  movq $1, %rax
  # file descriptor
  movq $1, %rdi
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
  movq $1, %rdi
  movq STR2(%rbp), %rsi
  # length of the data
  movq STR2_L(%rbp), %rdx
  syscall
  movq $1, %rax
  syscall
  subq $1, ITR(%rbp)
  jnz loop
  leave
  ret
