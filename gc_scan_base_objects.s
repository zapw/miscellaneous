.globl gc_scan_base_objects
.section .rodata
.section .text
gc_scan_base_objects:
 pushq %rbp
 movq %rsp, %rbp
 # the 'end' of the stack is the beginning
 # of the memory of the stack
 movq stack_end, %rdi
 # size is in %rsi
 movq stack_start, %rsi
 subq %rdi, %rsi
 call gc_scan_memory
 # .rodata is the first data segment
 movq $.rodata, %rdi
 andq $0xfffffffffffffff8, %rdi # Align to an 8-byte boundary
 # _end marks the end of data
 movq $_end, %rsi
 subq %rdi, %rsi
 call gc_scan_memory
 leave
 ret
