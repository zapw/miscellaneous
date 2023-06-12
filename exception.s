#try nested try / catch blocks see how it behaves using this logic 16.7 Exception handling 'learning to program with assembly'
.equ my_exception_code, 7 # Just picking a value at random
myfunc:
 pushq %rbp
 movq %rsp, %rbp

 push $0 # Needed to keep the stack aligned
 push $myfunc_exceptionhandler
 call myfunc2
 # DoMoreStuff
myfunc_ContinueMyFunc:
 # Do more stuff here
 leave
 ret
myfunc_exceptionhandler:
 # HandleException - do any exception-handling code here
 # Go back to the code
 jmp myfunc_ContinueMyFunc
myfunc2:
 pushq %rbp
 movq %rsp, %rbp

 pushq $0 # keep the stack aligned
 pushq $myfunc2_exceptionhandler
 call myfunc3
 #some code down here if didn't goa via exception route
 leave
 ret
myfunc2_exceptionhandler:
 # Nothing to do except go to the next handler
 leave # restore %rsp/%rbp  #movq %rbp, %rsp, popq %rbp 
 addq $8, %rsp # Get rid of return address
 jmp *(%rsp) # jump to exception handler
myfunc3:
 pushq %rbp
 movq %rsp, %rbp
 # Throw
 movq $my_exception_code, %rax # store exception code
 leave # restore %rsp/%rbp  #movq %rbp, %rsp, popq %rbp 
 addq $8, %rsp # Get rid of return address
 jmp *(%rsp) # Jump to exception handler
 # What would have happened if we didn't throw the exception
 leave
 ret

