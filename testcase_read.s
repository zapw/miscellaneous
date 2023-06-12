.globl main

.section .rodata
filename_read:
  .string "govdates.txt"
filename_read_excel:
  .string "exceldates.txt"
openmode:
  .string "r"
read_fmt:
  .string "%s%s"
read_fmt_excel:
  .string "%s"
  
outfmt:
  .string "%s %s\n"

.section .bss
.equ number_of_lines_excel, 15823
.equ number_of_lines_gov, 11507
excel_entries:
  .space $number_of_lines_excel*16
govils_entries:
  .space number_of_lines_gov*32
y:
   .space 8
z:
   .space 8

.equ inputfile, -8
.equ inputfile_excel, -16
.equ date_govils, -32
.equ price_govils, -16
.equ date_excel, -16
.section .text
main:
  pushq %rbp
  movq %rsp, %rbp
  subq $16, %rsp
 
 ### open the two files for reading
  movq $filename_read, %rdi
  movq $openmode, %rsi
  call fopen
  movq %rax, inputfile(%rbp) #save file pointer

  movq $filename_read_excel, %rdi
  movq $openmode, %rsi
  call fopen
  movq %rax, inputfile_excel(%rbp) #save file pointer excel
  ### end 

movq %rax, %rdi
call copyto_memory_excel
#read the date and price from govfile first line
  movq inputfile(%rbp), %rdi
  movq $read_fmt, %rsi
  leaq date_govils(%rbp), %rdx 
  leaq price_govils(%rbp), %rcx
#end 

#call function
  xor %eax, %eax
  call fscanf
#end
  
# comapre excel date with govils date
  movq date_excel(%rbp), %rax
  cmpq %rax, date_govils(%rbp)
# equal then jump
  je printit
#end



  movq -8(%rbp), %rdi #file pointer
  call fclose

  leave
  ret

 printit:
  movq stdout, %rdi
  movq $outfmt, %rsi
  leaq date_excel(%rbp), %rdx
  leaq price_govils(%rbp), %rcx
  xor %eax, %eax
  call fprintf

copyto_memory_excel:
  pushq %rbp
  movq %rsp, %rbp
  pushq %rdi
  subq $8, %rsp
# read the date from excel file first line
  movq -8(%rbp), %rdi
  movq $read_fmt_excel, %rsi
  leaq date_excel(%rbp), %rdx
#end

#call function
  xor %eax, %eax
  call fscanf
  movq date_excel(%rbp), 
# end
