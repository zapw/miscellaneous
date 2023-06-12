.section .text
.globl _start
_start:
  movq $message, %rdi
  call puts

message:
  .ascii "Hello, world!\n"
