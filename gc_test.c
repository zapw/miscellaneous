#include <stdio.h>
void *gc_allocate(int);
void gc_scan();
void gc_init();
volatile void **foo;
volatile void **goo;
/*
allocation 4 makes allocation 3 go away ,
allocation 5 takes allocation 3 and makes allocation 4 go
away, allocation 6 is big and makes allocation 1 and 2 go away
but dosent fit in allocation 4, allocation 7 is small makes allocation 5 go away and fits in allocation 1, allocation 8 is small and fits in allocation 2

*/

int main() {
 gc_init();

 foo = gc_allocate(500);
 fprintf(stdout, "Allocation 1: %p\n", foo);

 goo = gc_allocate(200);
 foo[0] = goo; // Hold reference to goo so it won't go away
 fprintf(stdout, "Allocation 2: %p\n", goo);

 gc_scan();
 goo = gc_allocate(300);
 fprintf(stdout, "Allocation 3: %p\n", goo);
 
 gc_scan();
 goo = gc_allocate(200);
 fprintf(stdout, "Allocation 4: %p\n", goo);

 gc_scan();
// This will be put in the same spot as allocation 3
 goo = gc_allocate(200);
 fprintf(stdout, "Allocation 5: %p\n", goo);

 gc_scan();
 foo = gc_allocate(500); // No longer holding reference to allocations 1 & 2
 fprintf(stdout, "Allocation 6: %p\n", foo);

 gc_scan();
 // This will be put in the same spot as allocation 1
 goo = gc_allocate(10);
 fprintf(stdout, "Allocation 7: %p\n", goo);
 // This will be put in the same spot as allocation 2
 foo = gc_allocate(10);
 fprintf(stdout, "Allocation 8: %p\n", foo);
}
