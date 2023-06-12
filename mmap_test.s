.globl allocate, deallocate

.equ readwrite, 0x1 | 0x2
.equ anonymous, 0x22 # dont use a file

.type allocate_mmap, @function
.type allocate, @function
.type deallocate, @function
.section .rodata
fmt_outp:
  .string "%p\n"

.section .bss
init_page:
  .space 8

.equ PAGE_SIZE, 4096
.equ NEXT_ALLOC_PAGES_SIZE, 16
.equ HDR_USENDSIZE, 16
.equ HDR_NEXT_ALLOC_OFFSET, 0
.equ HDR_PAGES, 8
.equ HDR_IN_USE_OFFSET, 0
.equ HDR_SIZE_OFFSET, 8
.equ MMAP_SYSCALL, 9
.equ SIZE_STACK, -8 #saved requested size location on the stack
.equ PAGESIZE_STACK, -16 #saved size of pages location on the stack
.equ NEXT_PAGE_STACK, -24
.equ CURR_PAGE_STACK, -48
.equ PAGE_END_STACK, -32
.equ PREV_END_STACK, -40
.equ R_BDARY, 16 # round to 16 bytes boundary
.equ TOTAL_HDR_SIZE, 32 #

.section .rodata
fmt:
  .string "%p\n"
.section .text
allocate_init:
  movq PAGESIZE_STACK(%rbp), %rax
  xor %edi, %edi
  movq %rax, %rsi
  xor %eax, %eax
  call allocate_mmap
  movq PAGESIZE_STACK(%rbp), %rdi
  movq %rdi, HDR_PAGES(%rax)
  movq %rax, init_page
  addq $NEXT_ALLOC_PAGES_SIZE, %rax
  movq $1, HDR_IN_USE_OFFSET(%rax)
  movq SIZE_STACK(%rbp), %rdi
  movq %rdi, HDR_SIZE_OFFSET(%rax)
  addq $HDR_USENDSIZE, %rax # point to the start of data
  
  leave
  ret

allocate:
  pushq %rbp
  movq %rsp, %rbp
  
  subq $48, %rsp
  movq $0, PREV_END_STACK(%rbp)
  #rdi has size
  movq $R_BDARY, %rsi #round to 16
  call roundnum
  movq %rax, SIZE_STACK(%rbp) #put back correct size

 #round to 4k pages
  movq %rax, %rdi
  addq $TOTAL_HDR_SIZE, %rdi
  movq $PAGE_SIZE, %rsi
  call roundnum
  movq %rax, PAGESIZE_STACK(%rbp) #save sum bytes of total pages
 
  movq init_page, %rax
  cmpq $0, %rax
  jz allocate_init
  
allocate_loop_pages:
  cmpq $0, %rax
  jz allocate_new_pages
  
  movq %rax, CURR_PAGE_STACK(%rbp) #save current page address on the stack

  movq HDR_NEXT_ALLOC_OFFSET(%rax), %rdx

  movq %rdx, NEXT_PAGE_STACK(%rbp)
  movq HDR_PAGES(%rax), %rdx
  addq %rax, %rdx
  subq $1, %rdx # remember counting from 0
  movq %rdx, PAGE_END_STACK(%rbp)
  
  addq $NEXT_ALLOC_PAGES_SIZE, %rax


allocate_loop_blocks:
  movq SIZE_STACK(%rbp), %rdx
  addq $HDR_USENDSIZE, %rdx
  addq %rax, %rdx #rdx points to = %rax (pass end of block) + requested block size + block header size
  subq $1, %rdx #-1 (counting fom 0)

  
#PAGE_END_STACK should point to last byte of the current contiguous allocated page/s
  cmpq PAGE_END_STACK(%rbp), %rdx
  ja next_page

  cmpq $1, HDR_IN_USE_OFFSET(%rax)
  je next_block

  movq HDR_SIZE_OFFSET(%rax), %rdx
  cmpq $0, %rdx
  jz addnewblock

  cmpq %rdx, SIZE_STACK(%rbp)
  ja next_block

  movq $1, HDR_IN_USE_OFFSET(%rax)
  addq $HDR_USENDSIZE, %rax
  leave
  ret

addnewblock:
  movq $1, HDR_IN_USE_OFFSET(%rax)
  movq SIZE_STACK(%rbp), %rdx
  movq %rdx, HDR_SIZE_OFFSET(%rax)
  addq $HDR_USENDSIZE, %rax
  leave
  ret

next_block:
  movq %rax, %rdx
  addq HDR_SIZE_OFFSET(%rax), %rdx
  addq $HDR_USENDSIZE, %rdx
  movq %rdx, %rax
  jmp allocate_loop_blocks

next_page:
  movq CURR_PAGE_STACK(%rbp), %rax 
  movq %rax, PREV_END_STACK(%rbp) #save current page address to prev on the stack load next page address from the stack to rax
  movq NEXT_PAGE_STACK(%rbp), %rax

  jmp allocate_loop_pages


roundnum:
#rsi has requested round size
  pushq %rbp
  movq %rsp, %rbp
  movq %rsi, %rax
  negq %rax
#rdi has size
  andq %rdi, %rax
  cmpq %rdi, %rax
  je skip
#is at boundary equal so jump to skip, else round up
  addq %rsi, %rax 
skip:
  leave
  ret
###
 
allocate_mmap:
  pushq %rbp
  movq %rsp, %rbp

  movq $readwrite, %rdx #pages have readwrite access
  movq $anonymous, %r10
  xor %r8, %r8 #fd
  xor %r9, %r9 #offset
  movq $MMAP_SYSCALL, %rax
  syscall 

  leave
  ret
  
allocate_new_pages:
  movq PAGESIZE_STACK(%rbp), %rax
  xor %edi, %edi
  movq %rax, %rsi
  xor %eax, %eax
  call allocate_mmap
  movq PREV_END_STACK(%rbp), %rdi
  movq %rax, HDR_NEXT_ALLOC_OFFSET(%rdi)

  movq PAGESIZE_STACK(%rbp), %rdi
  movq %rdi, HDR_PAGES(%rax)
  addq $NEXT_ALLOC_PAGES_SIZE, %rax
  movq $1, HDR_IN_USE_OFFSET(%rax)
  movq SIZE_STACK(%rbp), %rdi
  movq %rdi, HDR_SIZE_OFFSET(%rax)
  addq $HDR_USENDSIZE, %rax # point to the start of data
  
  leave
  ret

deallocate:
  pushq %rbp
  movq %rsp, %rbp
# Free is simple - just mark the block as available
  movq $0, HDR_IN_USE_OFFSET - HDR_USENDSIZE(%rdi)
  leave
  ret


