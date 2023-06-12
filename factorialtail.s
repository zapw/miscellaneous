.globl factorial
 .section .text
factorial:
  # No stack frame needed, just get ready to call factorial_internal
  # %rdi already has number,
  # value_so_far gets set to 1
  movq $1, %rsi
  # We can eliminate this as a tail call as well!
  jmp factorial_internal
factorial_internal:
  # No stack frame needed
  # %rdi has number
  # %rsi has value_so_far
  cmpq $1, %rdi
  je factorial_internal_completion
  # multiply number and value_so_far
  movq %rsi, %rax
  mulq %rdi
  # Next value
  decq %rdi # number
  movq %rax, %rsi # value_so_far
  # Tail call elimination
  jmp factorial_internal
factorial_internal_completion:
  # This is the base case - return value_so_far
  movq %rsi, %rax
  ret
 
