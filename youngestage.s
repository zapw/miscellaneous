.globl _start

.section .text
_start:
    #jmp mainloop(%rax,%rdi)
    #jmp *mainloop
    movq $0, %rdi
    movq $0, %rsi
    movq numpeople, %rcx # set number of structs in array
    movq $people, %rbx # set base address of first struct in the array
    movq NAME_PTR_OFFSET(%rbx,%rdi), %rdx # move first 8bytes of NAME of person to register
    movq %rdx, %rax
mainloop:
    decq %rcx
    jz endprogram
    addq $PERSON_RECORD_SIZE, %rdi 
    incq %rsi
    movq AGE_OFFSET(%rbx,%rdi), %rdx # move age of person to register
    cmpq %rdx, %rax
    jb mainloop
    movq %rdx, %rax
    movq %rsi, target_element
    jmp mainloop
 endprogram:
    movq target_element, %rdi
    movq $60, %rax
    syscall
    


