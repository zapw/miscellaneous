#include <stdio.h>
void *allocate(void*, long);
void dealloc_pool(void*);
void *new_pool();

int main() {
 // Get 400 bytes from pool 1
 void* pool1 = new_pool();
 printf("%p\n",pool1);
// void *a1 = allocate(pool1, 400);
// printf("%p\n",a1);
 // Get 32 bytes from pool 2
 void *a2 = allocate(pool1, 80);
 printf("%p\n",a2);
 // Get 80 bytes from pool 2
 void *ae = allocate(pool1, 80);
 printf("%p\n",ae);
 
 // Release all of pool1
 dealloc_pool(pool1);

 void* pool2 = new_pool();
 printf("%p\n",pool2);
// void *a1 = allocate(pool1, 400);
// printf("%p\n",a1);
 // Get 32 bytes from pool 2
 void *a55 = allocate(pool2, 80);
 printf("%p\n",a55);
 // Get 80 bytes from pool 2
 void *ae55 = allocate(pool2, 80);
 printf("%p\n",ae55);
 void* pool3 = new_pool();
 printf("%p\n",pool3);
 void *ae56 = allocate(pool2, 80);
 printf("%p\n",ae56);
 dealloc_pool(pool3);
 

}
