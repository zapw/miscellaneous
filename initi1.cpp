#include <iostream>
#include <string>
using namespace std;

struct B0 { 
	char x[5];
}; 

struct B1 {
	char x[10]; 
}; 

struct D : B0, B1 {
       	char x[3]; 
}; 

int main (void) {


D d;


cout << &d << '\n' << &d+1;
cout << '\n' << (B0*)(&d) << '\n' << (B1*)(&d);
}

//0x502910, 0x502910, 0x502915, 0x502922

