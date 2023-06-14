#include <iostream>
class Con {
	public:
	int b;
	int operator()(int x){
		return x+x;
	};
	Con (int a) : b{a} {};
};

int Con (int a){
	std::cout << "hi";
	return 1111;
}


int main(){
	class Con Con{5};
	std::cout << Con(4);
}
