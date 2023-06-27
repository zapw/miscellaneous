.globl VTABLE_SHAPE_AREA_OFFSET
.globl rectangle_vtable_shape
.globl triangle_vtable_shape
.equ VTABLE_SHAPE_AREA_OFFSET, 0
rectangle_vtable_shape:
 .quad rectangle_area
triangle_vtable_shape:
 .quad triangle_area
