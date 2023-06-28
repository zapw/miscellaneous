## Cat Class
.globl cat_new, cat_eat, cat_speak, cat_destroy
.section .data
speak_text:
 .ascii "Meow\n\0"
eat_text:
 .ascii "Yum, yum fish\n\0"
play_text:
 .ascii "Ball of string, Yay!\n\0"
.section .text
.equ CAT_SIZE, 64
cat_new:
 enter $0, $0
 movq $CAT_SIZE, %rdi
 call malloc
 movq $cat_methods, (%rax)
 movq $CAT_END, 8(%rax)
 leave
 ret
cat_speak:
 enter $0, $0
 movq stdout, %rdi
 movq $speak_text, %rsi
 call fprintf
 leave
 ret
cat_eat:
 enter $0, $0
 movq stdout, %rdi
 movq $eat_text, %rsi
 call fprintf
 leave
 ret
cat_destroy:
 enter $0, $0
 # %rdi already has the address
 call free
 leave
 ret
 