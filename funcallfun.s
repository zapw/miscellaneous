.globl funcallfun

.type funcallfun, @function
.section .text

funcallfun:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
  movq %rdi, -8(%rbp)
  
  xor %rdx, %rdx
  movq -8(%rbp), %rax
  movq -8(%rbp), %rdi
  cqo
  movq $2, %rcx
  idivq %rcx
  cmpq $0, %rdx
  jne uneven
  call factorial
  leave
  ret
uneven:
  xor %rdx, %rdx
  movq $3, %rsi
  call exponent
  leave
  ret
