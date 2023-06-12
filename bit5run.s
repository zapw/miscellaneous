.globl _start

.equ bit1, 0b110000010100101110111110
.equ bit2, 0b010101010101000011110111
.equ bit3, 0b010100101001110101111000


.section .text
_start:
  movq $bit1, %rdi
  movq $bit2, %rsi
  movq $bit3, %rdx
  
  call bit5fun
  movq %rax, %rdi
  movq $0x3c, %rax
  syscall
