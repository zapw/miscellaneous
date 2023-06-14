.globl gc_scan_memory

.section .text

gc_scan_memory:
#rsi has size to scan
#rdi has address of the first pointer
 
 xorq %r8, %r8
 xorq %r9, %r9
loop:
 addq $8, %r8
 cmpq %rsi, %r8
 ja endloop
 
 movq -8(%rdi,%r8), %r9
 cmpq heap_start, %r9
 jbe loop
 cmpq heap_end, %r9
 ja loop
 
 movq pointer_list_current, %rax 
 addq $8, %rax
 cmpq pointer_list_end, %rax
 ja endloop

 movq %r9, -8(%rax)
 movq %rax, pointer_list_current
 jmp loop
endloop:
 ret
 