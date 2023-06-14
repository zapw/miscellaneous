#include <iostream>
struct X {
     static inline int i = 8;
};



inline int xx {45};
//constexpr int X::i;
int main(){
	//X::i = 1;
	int y = 10;
	std::cout << &X::i;
}
