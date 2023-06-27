.globl triangle_new, triangle_area, triangle_destroy
.section .data
text_area:
 .ascii "The area of triangle is: %lld\n\0"
base:
 .quad 5
height:
 .quad 12

.section .text
.equ RECTANGLE_SIZE, 32
triangle_new:
 pushq %rbp
 movq %rsp, %rbp
 movq $RECTANGLE_SIZE, %rdi
 call malloc
 movq $triangle_vtable_shape, (%rax)
 movq base, %rdx
 movq %rdx, 8(%rax)
 movq height, %rdx
 movq %rdx, 16(%rax)
 leave
 ret
triangle_area:
 pushq %rbp
 movq %rsp, %rbp
 movq 8(%rdi), %rax
 mulq 16(%rdi)
 xor %edx, %edx
 movq $2, %rcx
 divq %rcx
 movq %rax, %rdx

 movq stdout, %rdi
 movq $text_area, %rsi
 call fprintf
 leave
 ret
triangle_destroy:
 pushq %rbp
 movq %rsp, %rbp
 # %rdi already has the address
 call free
 leave
 ret
 