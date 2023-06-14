#include <iostream>

class foo {
	public:
	int b;
	foo (int a) {b = a;};
};

class fun {
	public:
	fun () {};
	int arr[3];
	foo x{1};
	int a{4};
	fun (int c): arr{c,1,3}, x{12}  { 
		a = 3;
	};
};

int main(){
   fun f{2};
  //std::cout << f.a << a;
  std::cout << f.x.b;
}
