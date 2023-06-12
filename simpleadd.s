.globl _start

.section .data
source:
  .quad 9, 23, 55, 1, 3
.section .bss
dest:
  .space 40
  #.quad 0, 0, 0, 0, 0
.section .rodata
string:
  .string "hummus chips salad"
string1:
  .string "hummus chips salad"
.section .bss
byte:
  .space 1

.section .text
_start:
  movq $string, %rsi
  movq $string1, %rdi
  movq $22, %rcx
  movq $byte, %rax
  movb $3, %ss:(%rax)
  scasq
  #repe cmpsb
  #repz cmpsb %es:(%rdi),%ds:(%rsi)
  repz cmpsb %es:(%rdi), %ds:(%rsi)
  movq %rcx, %rdi
  movq $60, %rax
  syscall

