.include "gc_defs.s"
.globl gc_walk_pointers
.equ LCL_SAVED_RBX, -16
gc_walk_pointers:
 pushq %rbp
 movq %rsp, %rbp
 subq $16, %rsp
 # %rbx is supposed to be preserved - save it
 movq %rbx, LCL_SAVED_RBX(%rbp)
 # get initial value of `current' pointer
 movq pointer_list_start, %rbx
loop:
 # End of the list?
 cmpq %rbx, pointer_list_current
 je finished
 # Get the next potential pointer
 movq (%rbx), %rdi
 # Skip if already checked/marked
 cmpq $1, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
 je continue
 # Is it valid?
 call gc_is_valid_ptr
 cmpq $1, %rax
 jne continue
 # Valid pointer
 # Mark as valid
 movq (%rbx), %rdi
 movq $1, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
 # Scan contents of memory area for other pointers
 movq HDR_SIZE_OFFSET - HEADER_SIZE(%rdi), %rsi
 subq $HEADER_SIZE, %rsi 
 call gc_scan_memory
continue:
 # Next pointer
 addq $8, %rbx
 jmp loop
finished:
 # Restore %rbx
 movq LCL_SAVED_RBX(%rbp), %rbx
 leave
 ret
