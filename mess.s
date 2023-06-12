.section .data
numerator:
 # .quad 0xffffffffffffffff, 0xffffffffffffffff
 # .quad 0x0000000000000001, 0x0000000000000001
  #.quad 0x0123456789abcdef, 0x0123456789abcdef, 0x0123456789abcdef, 0x0123456789abcdef
  .quad 0x0000000000000000, 0xffffffffffffffff
divisor:
  #.quad 0x0000000000000001
  .quad 0xffffffffffffffff

.section .text
.globl _start
_start:
  movq numerator, %rax    # 
  movq 8+numerator, %rdx  
  movq divisor, %rcx      
  divq %rcx                     
  movq $3, %rdi
  movq $60, %rax                # System call number for exit
  syscall    
