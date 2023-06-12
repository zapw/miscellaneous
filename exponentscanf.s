.globl main
.section .data
promptformat:
 .ascii "Enter two numbers separated by spaces, then press return.\n\0"
scanformat:
 .ascii "%d %d\0"
resultformat:
 .ascii "The result is %d.\n\0"
.section .text
.equ LOCAL_NUMBER, -8
.equ LOCAL_EXPONENT, -16
main:
 # Allocate space for two local variables
 pushq %rbp
 movq %rsp, %rbp 
 subq $16, %rsp
 # Show the prompt to stdout
 movq stdout, %rdi
 movq $promptformat, %rsi
 movq $0, %rax
 call fprintf
 # Request the data
 movq stdin, %rdi
 movq $scanformat, %rsi
 movq $0, LOCAL_NUMBER(%rbp)
 movq $0, LOCAL_EXPONENT(%rbp)
 leaq LOCAL_NUMBER(%rbp), %rdx
 leaq LOCAL_EXPONENT(%rbp), %rcx
 movq $0, %rax
 call fscanf
 movq LOCAL_NUMBER(%rbp), %rdi
 movq LOCAL_EXPONENT(%rbp), %rsi
 call exponent
 movq stdout, %rdi
 movq $resultformat, %rsi
 movq %rax, %rdx
 movq $0, %rax
 call fprintf
 leave
 ret

exponent:
 # %rdi has the base
 # %rsi has the exponent
 # Create the stack frame with one 8-byte local variable
 # which will be referred to using -8(%rbp).
 # This will store the current value of the exponent
 # as we iterate through it.
 # We are allocating 16 bytes so that we maintain
 # 16-byte alignment.
 pushq %rbp
 movq %rsp, %rbp 
 subq $16, %rsp

 # Accumulated value in %rax
 movq $1, %rax
 # Store the exponent
 movq %rsi, -8(%rbp)
mainloop:
 mulq %rdi
 decq -8(%rbp)
 jnz mainloop
complete:
 # Result is already in %rax
 leave
 ret

