.globl allocate, deallocate, deallocate_pool
.section .data
memory_start:
 .quad 0
memory_end:
 .quad 0
.section .text
.equ HEADER_SIZE, 32 # Only need 24, but this is a 16-byte aligned value
.equ HDR_IN_USE_OFFSET, 0
.equ HDR_SIZE_OFFSET, 8
.equ HDR_POOL_OFFSET, 16
.equ BRK_SYSCALL, 12
# Register usage:
# - %r10 - memory pool #
# - %rdx - size requested
# - %rsi - pointer to current memory being examined
# - %rcx - copy of memory_end
allocate_init:
 # Find the program break.
 movq $0, %rdi
 movq $BRK_SYSCALL, %rax
 syscall
 # The current break will be both the start and end of our memory
 movq %rax, memory_start
 movq %rax, memory_end
 jmp allocate_continue
allocate_move_break:
 # Old break is saved in %r8 to return to user
 movq %rcx, %r8
 # Calculate where we want the new break to be
 # (old break + size)
 movq %rcx, %rdi
 addq %rdx, %rdi
 # Save this value
 movq %rdi, memory_end
 # Tell Linux where the new break is
 movq $BRK_SYSCALL, %rax
 syscall
 # Address is in %r8 - mark size, availability, and pool
 movq $1, HDR_IN_USE_OFFSET(%r8)
 movq %rdx, HDR_SIZE_OFFSET(%r8)
 movq %r10, HDR_POOL_OFFSET(%r8)
 # Actual return value is beyond our header
 addq $HEADER_SIZE, %r8
 movq %r8, %rax
 ret
 # This version of allocate has
 # two parameters - pool # and size
allocate:
 # Save the pool number int r10
 movq %rdi, %r10
 # Save the amount requested into %rdx
 movq %rsi, %rdx
 # Actual amount needed is actually larger
 addq $HEADER_SIZE, %rdx
 # If we haven't initialized, do so
 cmpq $0, memory_start
 je allocate_init
allocate_continue:
 movq memory_start, %rsi
 movq memory_end, %rcx
allocate_loop:
 # If we have reached the end of memory
 # we have to allocate new memory by
 # moving the break.
 cmpq %rsi, %rcx
 je allocate_move_break
 # is the next block available?
 cmpq $0, HDR_IN_USE_OFFSET(%rsi)
 jne try_next_block
 # is the next block big enough?
 cmpq %rdx, HDR_SIZE_OFFSET(%rsi)
 jb try_next_block
 # This block is great!
 # Mark it as unavailable
 movq $1, HDR_IN_USE_OFFSET(%rsi)
 # Set the pool #
 movq %r10, HDR_POOL_OFFSET(%rsi)
 # Move beyond the header
 addq $HEADER_SIZE, %rsi
 # Return the value
 movq %rsi, %rax
 ret
try_next_block:
 # This block didn't work, move to the next one
 addq HDR_SIZE_OFFSET(%rsi), %rsi
 jmp allocate_loop
deallocate:
 # Free is simple - just mark the block as available
 movq $0, HDR_IN_USE_OFFSET - HEADER_SIZE(%rdi)
 movq $0, HDR_POOL_OFFSET - HEADER_SIZE(%rdi)
 ret
deallocate_pool:
 # %rdi has the pool number
 # Walk the allocations and deallocate
 # anything with the pool number
 movq memory_start, %rsi
 movq memory_end, %rcx
deallocate_pool_loop:
 cmpq %rsi, %rcx
 je deallocate_loop_complete
 cmpq %rdi, HDR_POOL_OFFSET(%rsi)
 je deallocate_from_pool
 addq HDR_SIZE_OFFSET(%rsi), %rsi
 jmp deallocate_pool_loop
deallocate_from_pool:
 movq $0, HDR_POOL_OFFSET(%rsi)
 movq $0, HDR_IN_USE_OFFSET(%rsi)
 addq HDR_SIZE_OFFSET(%rsi), %rsi
 jmp deallocate_pool_loop
deallocate_loop_complete:
 ret
