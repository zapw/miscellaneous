.globl allocate, dealloc_pool, new_pool
.equ BRK_SYSCALL, 12
.equ HEADER_SIZE, 24
.equ HDR_NEXT_OFFSET, 0
.equ HDR_LAST_OFFSET, 8
.equ HDR_SIZE_OFFSET, 16

.equ HDR_POOL_HDR_SIZE, 8
.equ POOL_SIZE, 8
.equ HDR_POOL_NEXT_OFFSET, 0

.section .bss
free_list:  #head
  .space 8
free_list_end:  #tail
  .space 8
free_list_pool:
  .space 8 #head
heap_end:
  .space 8
  
.text 
#done
allocate_heap:
  cmpq $0, heap_end
  jne allocate_continue
  xor %rdi, %rdi
  movq $BRK_SYSCALL, %rax
  syscall
  movq %rax, heap_end

allocate_continue:
  movq %rsi, %rdi #request size
  addq $HEADER_SIZE, %rdi
  addq heap_end, %rdi
  movq $BRK_SYSCALL, %rax
  syscall
  movq %rax, heap_end
  movq %r8, %rdi #restore pool pointer
  subq %rsi, %rax
  subq $HEADER_SIZE, %rax
  movq %rsi, HDR_SIZE_OFFSET(%rax)

  movq (%rdi), %rdx
  cmpq $0, %rdx
  je move_to_pointer  #pointer has no allocations

  movq %rdx, HDR_NEXT_OFFSET(%rax)
  movq HDR_LAST_OFFSET(%rdx), %rdx
  movq %rdx, HDR_LAST_OFFSET(%rax)
  jmp skip_hdr_last_offset
move_to_pointer:
  movq %rax, HDR_LAST_OFFSET(%rax)
skip_hdr_last_offset:
  movq %rax, (%rdi)
  addq $HEADER_SIZE, %rax
  ret
#done

allocate:
  # rdi has pool pointer
  # rsi has size
  movq free_list, %rax 
  cmpq $0, %rax
  movq %rdi, %r8 #save pool pointer to %r8
  je allocate_heap
  movq %rax, %rcx #prev block and current start the same
  movq free_list_end, %r9
#walk free_list for a suitable block size
walk_free_list:
  cmpq HDR_SIZE_OFFSET(%rax), %rsi
  ja try_next_block
  #perfect found one, detach it from free_list 
  cmpq %rax, %rcx
  je move_one #it's the first block
  movq HDR_NEXT_OFFSET(%rax), %rdx
  movq %rdx, HDR_NEXT_OFFSET(%rcx)
  cmpq $0, %rdx
  je change_free_list_end
  jmp attach_to_pointer
change_free_list_end:
  movq %rcx, free_list_end
  jmp attach_to_pointer
try_next_block:
  movq %rax, %rcx
  movq HDR_NEXT_OFFSET(%rax), %rax
  cmpq $0, %rax
  je allocate_heap #walked entire list
  jmp walk_free_list
move_one:
  cmpq %r9, %rax
  je reset_end_list
  movq HDR_NEXT_OFFSET(%rax), %rdx
  movq %rdx, free_list
  jmp attach_to_pointer
reset_end_list:
  movq $0, free_list
  movq $0, free_list_end
attach_to_pointer:
  movq (%rdi), %rdx
  movq %rdx, HDR_NEXT_OFFSET(%rax)
  movq %rax, (%rdi)
  addq $HEADER_SIZE, %rax
  ret


#done
new_pool:
  movq free_list_pool, %rax 
  cmpq $0, %rax
  je allocate_heap_pool
#done
  
#done
  movq (%rax), %rdx
  movq %rdx, free_list_pool
  xor %rdx, %rdx #reset pointer
  movq %rdx, (%rax)
  ret
#done

#done
allocate_heap_pool:
  cmpq $0, heap_end
  jne allocate_pool_continue
  xor %rdi, %rdi
  movq $BRK_SYSCALL, %rax
  syscall
  movq %rax, heap_end

allocate_pool_continue:
  movq heap_end, %rdi
  addq $8, %rdi
  movq $BRK_SYSCALL, %rax
  syscall
  movq %rax, heap_end
  subq $8, %rax
  ret
#done
  
#done
dealloc_pool:
#add to free_list the allocations under the pool, if any
  movq (%rdi), %rax #get list of allocs from pointer
  cmpq $0, %rax
  je done_with_allocs
  movq free_list, %rdx
  cmpq $0, %rdx
  je move_allocs
  
  movq free_list_end, %rdx
  movq %rax, HDR_NEXT_OFFSET(%rdx)
  jmp pre_done_with_allocs

move_allocs:
  movq %rax, free_list

pre_done_with_allocs:
  movq HDR_LAST_OFFSET(%rax), %rdx
  movq %rdx, free_list_end

#add the pool pointer back to free_list_pool
done_with_allocs:
  #rdi has pool pointer
  cmpq $0, free_list_pool
  je addto_free_list_pool
  movq free_list_pool, %rax
  movq %rdi, free_list_pool
  movq %rax, (%rdi)
addto_free_list_pool:
  movq %rdi, free_list_pool
  ret
#done
