.globl main
.section .text
main:
 .equ LCL_RECTANGLE, -8
 .equ LCL_TRIANGLE, -16
 pushq %rbp
 movq %rsp, %rbp
 subq $32, %rsp
 # Construct a triangle
 call triangle_new
 movq %rax, LCL_TRIANGLE(%rbp)
 # Construct a rectangle
 call rectangle_new
 movq %rax, LCL_RECTANGLE(%rbp)
 movq LCL_TRIANGLE(%rbp), %rdi # Object
 movq (%rdi), %rsi #VTable
 #movq $triangle_vtable_shape, %rsi # VTable
 call findArea
 movq LCL_RECTANGLE(%rbp), %rdi # Object
 movq (%rdi), %rsi #VTable
 #movq $rectangle_vtable_shape, %rsi # VTable
 call findArea
 
 # Destructors
 movq LCL_RECTANGLE(%rbp), %rdi
 call rectangle_destroy
 movq LCL_TRIANGLE(%rbp), %rdi
 call triangle_destroy

 leave
 ret
