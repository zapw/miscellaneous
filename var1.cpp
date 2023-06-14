#include <iostream>



inline constexpr int l = 999;


extern  int x;
extern  int* p;
int main(){
	std::cout << x << '\n';
	std::cout << l << '\n';
	std::cout << p << '\n';
	std::cout << &l << '\n';
	std::cout << *p << '\n';
}
