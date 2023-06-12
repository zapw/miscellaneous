.globl _start


_start:
    movq $5, %rdi
    movb $0b00000011, %bl
    movb $0b11111111, %al
    addb $0b00000001, %al
    #cmpb %bl, %al 
    jc labeljmp

    movq $3, %rdi
labeljmp:
    movq $60, %rax
    syscall
