.globl _start
.section .data
mytext:
 .ascii "This Ais a sZtring of chzaracters.&^%$&#@\0"
.section .text
_start:
 ### Initialization
 # Move a pointer to the string into %rbx
 leaq mytext, %rbx
 # Count starts at zero
 movq $0, %rdi
mainloop:
 # Get the next byte
 movb (%rbx), %al
 # Quit if we hit the null terminator
 cmpb $0, %al
 je finish
 # Go to the next byte if the value isn't between a and z
 cmpb $'Z', %al
 ja loopcontrol_test1
 cmpb $'A', %al
 jb loopcontrol_good
 jmp nextbyte
loopcontrol_test1:
 cmpb $'z', %al
 ja loopcontrol_good
 # If not then see if it's less than 'a' 
 cmpb $'a', %al
 jb loopcontrol_good
 ## else jump to nextbyte
 jmp nextbyte
loopcontrol_good:
 incq %rdi
 # Next byte
 nextbyte:
 incq %rbx
 # Repeat
 jmp mainloop
finish:
 movq $60, %rax
 syscall
