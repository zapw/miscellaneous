#include <stdio.h>

void *allocate(void*, long);
void dealloc_pool(void*);
void *new_pool();
void setup_finalizer(void*, void (*)(void));

void foobar(){
    int x = 22;
    int c = 333;
    int z = c+x;
    printf("running finalizer foobar\n");
}
void finalizer(void){
//    foobar();
    printf("running finalizer\n");
}

int main() {
/*
 void* pool1 = new_pool();
 void *ae = allocate(pool1, 80);
 setup_finalizer(ae,finalizer);
 dealloc_pool(pool1);
 */

 
 // Get 400 bytes from pool 1
 void* pool1 = new_pool();
 printf("pool 1 is %p\n",pool1);
// void *a1 = allocate(pool1, 400);
// printf("%p\n",a1);
 // Get 32 bytes from pool 2
 void *a2 = allocate(pool1, 80);
 printf("%p\n",a2);
 // Get 80 bytes from pool 2
 void *ae = allocate(pool1, 80);
 printf("%p\n",ae);
 setup_finalizer(ae,finalizer);
 
 
 // Release all of pool1
 dealloc_pool(pool1);

 void* pool2 = new_pool();
 printf("pool 2 is %p\n",pool2);
// void *a1 = allocate(pool1, 400);
// printf("%p\n",a1);
 // Get 32 bytes from pool 2
 void *a55 = allocate(pool2, 80);
 setup_finalizer(a55,foobar);
 printf("%p\n",a55);
 // Get 80 bytes from pool 2
 void *ae55 = allocate(pool2, 80);
 setup_finalizer(ae55,foobar);
 printf("%p\n",ae55);
 void* pool3 = new_pool();
 printf("pool 3 is %p\n",pool3);
 void *ae56 = allocate(pool2, 80);
 printf("%p\n",ae56);
 void *ae5666 = allocate(pool3, 80);
 setup_finalizer(ae5666,finalizer);
 printf("%p\n",ae5666);
 dealloc_pool(pool3);
 dealloc_pool(pool2);
 void* pool5 = new_pool();
 printf("pool 5 is %p\n",pool5);
 void* pool6 = new_pool();
 printf("pool 6 is %p\n",pool6);

 void *ae5667 = allocate(pool1, 80);
 printf("%p\n",ae5667);
 long* foo = (long*)ae5667;
 *foo = 333;
 printf("%ld\n", *foo);

}
