#include <cmath>
#include <iostream>
#include <string>
#include <cassert>
#include <array>

using namespace std;
  
template< class T > struct foo     { foo(){ std::cout << "Hi";} ; };
template< class T > struct foo<T&>  { foo(){ std::cout << "XX";}; };
template< class T > struct foo<T&&> { foo(){ std::cout << "ZZ";}; };

int main(){
  int a = 5;
  int&& b = std::move(a);

  b = 4;
  //std::cout << std::move(a);
  //assert(false &&      "cheese cake"                           );
  //
   //short *aa  { new short[10] } ;
   //std::cout << hex << aa << '\n';
   //std::cout << hex << (aa + 1) << '\n';
   //std::cout << hex << (aa + 2) << '\n';
   //std::cout << hex << (aa + 3) << '\n';

  //foo<int&&> az;
  //long long** array { new long long*[10] };
  //*array[1] = 5;
  //**(array + 1) = 10;
  //std::cout << hex << array << '\n';
  //std::cout << hex << array + 1 << '\n';
  //std::cout << hex << array + 2 << '\n';
  //std::cout << hex << *array[1] << '\n';
  //for (int i = 0; i < 10; ++i){
//	  delete[] array[i];
  //}
  //delete[] array;
  int XXX = 5;
  //int (*arra)[4][3] = new int[XXX][4][3];
  //auto arra = new int[XXX][4][3][1];
  std::array<int,5> myArray;
  myArray = { 0, 1, 2, 3, 4 };
  std::array myArrayX { 9, 7, 5, 3, 1 };
}

