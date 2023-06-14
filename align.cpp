#include <iostream>

#include <stdio.h>
  
// Alignment requirements
// (typical 32 bit machine)
  
// char         1 byte
// short int    2 bytes
// int          4 bytes
// double       8 bytes
  
// structure A
struct cheese {
    char x;
    short int l[5];
    int Z;
    double XX;
};

typedef struct structa_tag
{
   cheese A; // 
   short int   s; // 
   char        c; //
   
 
} structa_t;
  
// structure B
typedef struct structb_tag
{
   char        c;
      short int   s;

   int         i;
} structb_t;
  
// structure C
typedef struct structc_tag
{
   char        c;
      int         s;

   double      d;
} structc_t;
  
// structure D
typedef struct structd_tag
{
   double      d;
   int         s;
   char        c;
} structd_t;
  struct Foo
{
    int   i;
    float f;
    char  c;
};
int main()
{
   printf("sizeof(structa_t) = %llu\n", sizeof(structa_t));
   printf("sizeof(structb_t) = %llu\n", sizeof(structb_t));
   printf("sizeof(structc_t) = %llu\n", sizeof(structc_t));
   printf("sizeof(structd_t) = %llu\n", sizeof(structd_t));
   printf("sizeof(cheese) = %llu\n", sizeof(cheese));
   printf("sizeof(Foo) = %llu\n", sizeof(Foo));
   //std::cout << offsetof(cheese, l);
   std::cout << alignof(cheese) << '\n';
   std::cout << alignof(structa_tag) << '\n';

      int* ptr = new int[2];
    char* char_ptr = reinterpret_cast<char*>(ptr);

    // This line of code will cause an alignment fault on some architectures
    *reinterpret_cast<int*>(char_ptr + 1) = 42;
    
    // Clean up memory
    delete[] ptr;

   return 0;
}
