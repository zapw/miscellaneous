.globl call_method

.text
call_method:
 pushq %rbp
 movq %rsp, %rbp
#rdi has object
#rsi has method number
#first quad word has pointer to method table
 xor %edx, %edx
 movq (%rdi), %rax
 movq 8(%rdi), %r8
loop:
 movq (%rax,%rdx,8), %rcx
 cmpq %rsi, %rcx
 je end_loop
 addq $2, %rdx
 cmpq %rdx, %r8
 je not_found
 jmp loop
end_loop:
 leaq (%rax,%rdx,8), %rax
 addq $8, %rax
 movq (%rax), %rax
 call *%rax
not_found:
 leave
 ret

