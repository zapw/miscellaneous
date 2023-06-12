# 128-bit dividend
.globl _start

.section .data
number:
    .quad 3
.section .text
_start:
    #movq $0xFFFFFFFFFFFFFFFF, %rdx
    movq $0xFFFFFFFFFFFFFFFF, %rcx
    #movq $0x0000000000000004, %rax
    #movq $o0xFFFFFFFFFFFFFFF, %rax
    #movq $-4, %rbx
    #movq $0xfffffffffffffffc, %rax
    #movq $4, %rax
    #cqo
    
    # 64-bit divisor
    #movq $0xFFFFFFFFFFFFFFFF, %rcx
    #movq $0x0000000000000003, %rcx
    #movq $0xffffffffffffffff, %rcx
    #movq $-3, %rbx
    #movq $0xfffffffffffffffd, %rcx
    #movq $1, %rcx
    
    #pushq %rax
    #movq %rdx, %rax
    #xorq %rdx, %rdx
    imulq number, %rcx                # get high 64 bits of quotient
    #idivq %rcx                # get high 64 bits of quotient
    #xchgq (%rsp), %rax       # store them on stack, get low 64 bits of dividend
    #divq %rcx                # get low 64 bits of quotient
    #popq %rdx                # 128-bit quotient in rdx:rax now
    movq $60, %rdx
    movq $3, %rdi
    syscall
    
    # rdx:rax should now be equal 0x0000000100000001 - dunno
    # rdx:rax should now be equal 0x00000000000000010000000000000001
