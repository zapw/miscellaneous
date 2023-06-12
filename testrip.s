.global _start

.data
foo:
  .quad 1

.text
_start:
  movq foo(%rip), %rax
  movq foo, %rax


