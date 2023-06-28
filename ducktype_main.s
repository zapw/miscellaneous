.globl main
.section .text
main:
 .equ LCL_CAT, -8
 .equ LCL_DOG, -16
 .equ LCL_SCREECHY, -24
 pushq %rbp
 movq %rsp, %rbp
 subq $32, %rsp
 # Construct a dog
 call dog_new
 movq %rax, LCL_DOG(%rbp)
 # Construct a cat
 call cat_new
 movq %rax, LCL_CAT(%rbp)
 # Construct screechy_cat
 call screechy_cat_new
 movq %rax, LCL_SCREECHY(%rbp)

 movq LCL_DOG(%rbp), %rdi # Object
 movq $1, %rsi #eat
 call call_method
 movq LCL_CAT(%rbp), %rdi # Object
 movq $1, %rsi #speak
 call call_method
 movq LCL_SCREECHY(%rbp), %rdi # Object
 movq $1, %rsi #eat
 call call_method

 
 # Destructors
 movq LCL_CAT(%rbp), %rdi
 movq $3, %rsi #destroy method
 call call_method
 movq LCL_DOG(%rbp), %rdi
 movq $3, %rsi #destroy method
 call call_method
 movq LCL_SCREECHY(%rbp), %rdi
 movq $3, %rsi #destroy method
 call call_method

 leave
 ret
