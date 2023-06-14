.globl gc_scan_init
# Make sure we *have* an rodata section, even if nothing is in there
.section .rodata
.section .text
gc_scan_init:
 pushq %rbp
 movq %rsp, %rbp
 # Mark end of stack
 movq %rsp, stack_end
 # Calculate max memory we could need for pointer storage into %rdi
 # - Stack size
 movq stack_start, %rdi
 subq %rsp, %rdi
 # - Data section size
 movq $.rodata, %rdx
 andq $0xfffffffffffffff8, %rdi # Align to 8-byte boundary
 movq $_end, %rcx
 subq %rdx, %rcx
 addq %rcx, %rdi
 # - Heap size
 movq heap_end, %rdx
 subq heap_start, %rdx
 addq %rdx, %rdi
 # The pointer space will be that many bytes
 # beyond the current heap end.
 movq pointer_list_start, %rdx
 addq %rdx, %rdi
 movq %rdi, pointer_list_end
 # pointer_list_start and _current start the same
 movq %rdx, pointer_list_current
 # Move the current break to this point
 # (new break already in %rdi)
 movq $BRK_SYSCALL, %rax
 syscall
 leave
 ret
