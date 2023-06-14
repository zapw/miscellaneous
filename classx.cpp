#include <iostream>

class C {
  int chips;
  public:
  C(int zx): chips{zx} { };
  void foo(){
	class LAM {
		C* ooo;
		public:
		LAM(C* xxx): ooo{xxx} {

		}
		void operator()(int z){
			std::cout << ooo->chips+z;
		};
	};
	LAM lambd{this};
	lambd(33);
  };
};

int main(){
 C c{222};
 c.foo();
}

I read lambda are functors, so I try to emulate how the capture of [this] would work with a functor, it says if I capture this I am able to access the enclosing class members without special naming syntax
