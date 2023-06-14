.include "gc_defs.s"
.globl gc_is_valid_ptr
.section .text
gc_is_valid_ptr:
 pushq %rbp
 movq %rsp, %rbp
 # %rdi has the pointer to check
 # Set %rcx to the first embedded pointer
 movq heap_start, %rcx
loop:
 leaq HEADER_SIZE(%rcx), %rax
 cmpq %rax, %rdi
 # It is the address - yay!
 je valid_ptr
 # We passed the address without finding it - boo!
 jb invalid_ptr
 # haven't gotten there yet - keep going
 # Find the location of the next pointer and loop
 addq HDR_SIZE_OFFSET(%rcx), %rcx
 jmp loop
invalid_ptr:
 movq $0, %rax
 leave
 ret
valid_ptr:
 movq $1, %rax
 leave
 ret
