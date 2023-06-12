#include <stdio.h>
#include <stdint.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>

#define handle_error(msg) \
    do { perror(msg); exit(EXIT_FAILURE); } while (0)

void *allocate(int);
//long long allocate(int);
void deallocate(void *);

void check_error(ssize_t s, size_t length){
  if (s != length) {
      if (s == -1)
          handle_error("write");
          fprintf(stderr, "partial write");
          exit(EXIT_FAILURE);
  }
}
int main() {
 uint8_t *a1 = allocate(8000);
 uint8_t *a4 = allocate(8100);
 uint8_t *a8 = allocate(90222);
 fprintf(stdout, "Allocations: %p, %p, %p\n", a1, a4, a8);
 
 for (int i = 0;i < 8000; i++){
    a1[i] = '1';
 }
 
 for (int i = 0;i < 8100; i++){
    a4[i] = '2';
 }
 
 for (int i = 0;i < 90222; i++){
    a8[i] = '3';
 }
 
 check_error(write(STDOUT_FILENO, a1, 8000),8000);
 check_error(write(STDOUT_FILENO, a4, 8100),8100);
 check_error(write(STDOUT_FILENO, a8, 90222),90222);
deallocate(a4);
  uint8_t *a9 = allocate(8000);
  uint8_t *a10 = allocate(212);
  uint8_t *a11 = allocate(1022);
  fprintf(stdout, "Allocations: %p, %p, %p, %p, %p, %p\n", a1, a4, a8, a9, a10, a11);
 for (int i = 0;i < 8000; i++){
    a9[i] = '4';
 }
 
 for (int i = 0;i < 212; i++){
    a10[i] = '5';
 }
 
 for (int i = 0;i < 1022; i++){
    a11[i] = '6';
 }
 
check_error(write(STDOUT_FILENO, a9, 8000),8000);
check_error(write(STDOUT_FILENO, a10, 212),212);
check_error(write(STDOUT_FILENO, a11, 1022),1022);
}
