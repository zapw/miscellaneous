

struct B { 
	void foo() { BARK; } 
}; 

struct D : B { 
	void foo() { BARK; } 

}; 

struct D2 : D { 
	void foo() { BARK; } 

}; // removed virtual

D *d = new D2;
d->foo();  

D::foo()



struct B { 
	virtual void foo() { BARK; } 
}; 

struct D : B { 
	void foo() { BARK; } 
}; 

struct D2 : D { 
	void foo() { BARK; } 
}; // zxd

D *d = new D2;
d->foo();  

D2::foo()

// converting from a D2* to a D* does absolutely nothing. `D2* p = new D2;` and `D* p = new D2;` produces exactly the same machine code. In both cases, p points to the beginning of D2. This is valid for a D* because the beginning of the D2 object contains the D subobject (the D2-specific members follow the D subobject). The D subobject contains a B subobject (and the D specific members follow it). 
//
//Then the B subobject contains the vptr, followed by B's members. There's only one vptr in all of this, which points to D2's vtable. So, the B subobject starts with a vptr which points to D2's vtable


//So you have: D2{ D{ B{ vptr; B members; } D members } D2 members }
//
//
//
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
cout << '\n' << static_cast<B0*>(&d) << '\n' << static_cast<B1*>(&d);
}

//0x502910, 0x502910, 0x502915, 0x502922

//PJBoy's example, assuming B0 and B1 have virtual functions, looks like: 
//   D{ 
//      B0{ vptr0; char x[5];  } 
//      B1{ vptr1; char x[10]; } 
//      char x[3]; 
//    }
//
//vptr0 is used for D* and B0*, while B1* uses vptr1
//So vptr0 and vptr1 both point to D's vtable, but vptr0 points at the beginning of it and vptr1 points into the middle of D's vtable, where the virtual functions inherited from B1 start at
//
//And note that `D* p = new D;` and `B0* p = new D;` produce identical machine code, but `B1* p = new D;` needs to do a pointer adjustment, since the D* returned by `new D` needs to be adjusted to point to the B1 subobject
//<Alipha> Which also means reinterpret_cast<B1*>(new D) is Udefined behavior, since reinterpret_cast won't do the pointer adjustment. And going from D* to void* to B1* is also Undefined behavior
