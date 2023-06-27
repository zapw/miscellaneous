.globl findArea
.section .text
findArea:
 .equ LCL_SHAPE_OBJ_OFFSET, -8
 .equ LCL_SHAPE_VTABLE_OFFSET, -16
 pushq %rbp
 movq %rsp, %rbp
 subq $16, %rsp
 movq %rdi, LCL_SHAPE_OBJ_OFFSET(%rbp)
 movq %rsi, LCL_SHAPE_VTABLE_OFFSET(%rbp)
 # %rdi already contains the object
 call *VTABLE_SHAPE_AREA_OFFSET(%rsi)
 movq LCL_SHAPE_OBJ_OFFSET(%rbp), %rdi
 movq LCL_SHAPE_VTABLE_OFFSET(%rbp), %rsi
 call *VTABLE_SHAPE_AREA_OFFSET(%rsi)
 movq LCL_SHAPE_OBJ_OFFSET(%rbp), %rdi
 movq LCL_SHAPE_VTABLE_OFFSET(%rbp), %rsi
 call *VTABLE_SHAPE_AREA_OFFSET(%rsi)
 movq LCL_SHAPE_OBJ_OFFSET(%rbp), %rdi
 movq LCL_SHAPE_VTABLE_OFFSET(%rbp), %rsi
 call *VTABLE_SHAPE_AREA_OFFSET(%rsi)
 leave
 ret
