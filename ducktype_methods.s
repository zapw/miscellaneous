.globl dog_methods, cat_methods, screechy_cat_methods
.globl CAT_END, DOG_END, SCREECHY_END
.section .data
.equ DOG_END, (dog_end - dog_methods)/8
.equ CAT_END, (cat_end - cat_methods)/8
.equ SCREECHY_END, (screechy_end - screechy_cat_methods)/8
dog_methods:
 .quad 1, dog_speak
 .quad 2, dog_eat
 .quad 3, dog_destroy
dog_end:
cat_methods:
 .quad 1, cat_speak
 .quad 2, cat_eat
 .quad 3, cat_destroy
 cat_end:

screechy_cat_methods:
 .quad 2, cat_eat
 .quad 3, screechy_cat_destroy
 .quad 1, screechy_cat_speak
 screechy_end:
