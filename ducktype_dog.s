## Dog Class
.globl dog_new, dog_eat, dog_speak, dog_destroy
.section .data
speak_text:
 .ascii "Ruff, ruff\n\0"
eat_text:
 .ascii "I love dog biscuits\n\0"
.section .text
.equ DOG_SIZE, 32
dog_new:
 enter $0, $0
 movq $DOG_SIZE, %rdi
 call malloc
 movq $dog_methods, (%rax)
 movq $DOG_END, 8(%rax)
 leave
 ret
dog_speak:
 pushq %rbp
 movq %rsp, %rbp
 movq stdout, %rdi
 movq $speak_text, %rsi
 call fprintf
 leave
 ret
dog_eat:
 enter $0, $0
 movq stdout, %rdi
 movq $eat_text, %rsi
 call fprintf
 leave
 ret
dog_destroy:
 enter $0, $0
 # %rdi already has the address
 call free
 leave
 ret
