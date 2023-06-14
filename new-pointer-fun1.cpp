#include <iostream>

class foo {
	public:
	int b{2};
	foo () {};
};

class fun {
	public:
	foo x;
	fun (): x() { 
	};
};

int main(){
   fun f;
   std::cout << f.x.b;
}
