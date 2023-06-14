// using namespace example
#include <stdio.h>


int main () {
    typedef struct { int a; } XX;
    typedef int (*Operation)(int a , int b );
    XX a;
    XX b;
    a.a = 5;
    b.a = 2;
    printf("%d", a.a);	
    printf("%d", b.a);	

  return 0;
}
