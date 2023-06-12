.globl _start
.section .data
prevcount:
    .quad 0
name_ptr:
    .quad 0
    
.section .text
_start:
    movq $0, %rdi
    movq $0, %rsi
    movq $0, %rdx
    movq numpeople, %rsi # set number of structs in array
    movq $people, %rbx # set base address of first struct in the array
mainloop:
    movq NAME_PTR_OFFSET(%rbx,%rdi), %rax # move NAME_PTR address to register
    movq (%rax), %rcx
    movq %rax, name_ptr
    jmp from_mainloop
innerloop_next8bytes:
    movq name_ptr, %rax
    addq $8, %rax
    movq %rax, name_ptr
    movq (%rax), %rcx
from_mainloop:
    movq %rcx, %rax
    movq $8, %rcx#keep track how many bytes of characters we loaded

equal_bigger_less_a_z_lowbyte:
    cmpb $0, %al
    je nextelement
    cmpb $'a', %al 
    jb test_if_bigger_than_Z_lowbyte # is less than 'a'
    cmpb $'z', %al # ok is it bigger  than 'z' ? 
    ja equal_bigger_less_a_z_highbyte # is bigger than 'z'
    incq %rdx # good between including 'a' and 'z'
    jmp equal_bigger_less_a_z_highbyte

 test_if_bigger_than_Z_lowbyte:
    cmpb $'Z', %al 
    ja equal_bigger_less_a_z_highbyte # it's bigger than 'Z' and smaller than 'a'
    cmpb $'A', %al
    jb equal_bigger_less_a_z_highbyte# is less than 'A'
    incq %rdx # good it's between 'A' and 'Z' including
    jmp equal_bigger_less_a_z_highbyte

equal_bigger_less_a_z_highbyte:
    cmpb $0, %ah
    je nextelement
    cmpb $'a', %ah
    jb test_if_bigger_than_Z_highbyte # is less than 'a'
    cmpb $'z', %ah # ok is it bigger  than 'z' ? 
    ja next2bytes # is bigger than 'z'
    incq %rdx # good between including 'a' and 'z'
    jmp next2bytes
    
test_if_bigger_than_Z_highbyte:
    cmpb $'Z', %ah
    ja next2bytes # it's bigger than 'Z' and smaller than 'a'
    cmpb $'A', %ah
    jb next2bytes# is less than 'A'
    incq %rdx # good it's between 'A' and 'Z' including
    jmp next2bytes

next2bytes:
    subq $2, %rcx
    jz innerloop_next8bytes
    rorq $16, %rax
    jmp equal_bigger_less_a_z_lowbyte

finish:
    movq prevcount, %rdi
    movq $60, %rax
    syscall
    
nextelement:
    cmpq prevcount, %rdx
    ja copyvalue
continue:
    movq $0, %rdx
    decq %rsi
    jz finish
    movq $people, %rbx
    addq $PERSON_RECORD_SIZE, %rdi 
    jmp mainloop

copyvalue:
    movq %rdx, prevcount
    jmp continue
