#include <iostream>
#include <array>


class A {
	public:
	static int num;
	A () {
		std::cout << "constructor" << num++ << '\n';
	}
	A(A&& a){
		std::cout << "move";
	}
	A(const A& a){
		std::cout << "copy";
	}
	void operator=(const A& a){
		std::cout << "copy assign";
	}
	void operator=(A&& a){
		std::cout << "move assign";
	}
};

int A::num{1};


int main(){
	std::array<A,10> arrA;	
	std::cout << "main\n";
	//arrA[0] = A();
	A aa = std::move(arrA[0]);
}
