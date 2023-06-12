.globl _start


_start:
    movq $0, %rax
    movq $0, %rbx
    movb $0b00000001, %al
    movb $0b00000011, %bl
    #negb %bl
    sub %bl, %al
    #addb %bl, %al
    movq $-3, %rcx
    movq %rax, %rdi
    #jc endjmp
    #jc endjmp
    #movq $3, %rdi
endjmp:
    movq $60, %rax
    syscall
