.globl _start
.section .data
mynum:
 .8byte 20 
mystring:
 .ascii "Hello there!\n"
 .ascii "Humus Chips Salad\n"
mystring_end:
mystringne:
 .ascii "Hello there !\n"
 .ascii "Hello there you had humuus today!\n"
mystring_endne:
.equ mystring_length, mystring_end - mystring
.equ mystring_lengthne, mystring_endne - mystringne
.section .text
_start:
 ### Display the string
 # System call number
loop:
 xor %rdx, %rdx
 movq mynum, %rax
 movq $2, %rbx
 divq %rbx
 cmpq $0, %rdx
 jne uneven
 movq $1, %rax
 # file descriptor
 movq $1, %rdi
 # pointer to the data
 movq $mystring, %rsi
 # length of the data
 movq $mystring_length, %rdx
 syscall
 subq $1, mynum
 jnz loop
 jmp endprogram
uneven:
 movq $1, %rax
 # File descriptor
 movq $1, %rdi
 movq $mystringne, %rsi
 # length of the data
 movq $mystring_lengthne, %rdx
 syscall
 subq $1, mynum
 jnz loop

 ### Exit
endprogram:
 movq $0x3c, %rax
 movq $0, %rdi
 syscall
