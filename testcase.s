.globl main


format:
  .ascii "%ld %ld %ld %ld %ld %ld %ld\0"
  #.ascii "%ld %ld %ld %ld\0"

main:
  pushq %rbp
  movq %rsp, %rbp
  subq $64, %rsp #reserve for 7 parameters of them: 4 passed to registers, 3 saved on the stack and 1 for padding to 16 byte boundary ( the first highest address)
  movq stdin, %rdi
  movq $format, %rsi
  leaq -16(%rbp), %rdx
  leaq -24(%rbp), %rcx
  leaq -32(%rbp), %r8
  leaq -40(%rbp), %r9
  leaq -48(%rbp), %rax
  movq %rax, -48(%rbp)
  leaq -56(%rbp), %rax
  movq %rax, -56(%rbp)
  leaq -64(%rbp), %rax
  movq %rax, -64(%rbp)
  xor %eax, %eax
  call fscanf
  #movq -48(%rbp), %rax

  leave
  ret
