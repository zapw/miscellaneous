.globl gc_scan_cleanup
gc_scan_cleanup:
 # Done with the pointer list - move break back to where it was
 movq $BRK_SYSCALL, %rax
 movq heap_end, %rdi
 syscall

