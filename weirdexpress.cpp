#include <iostream>

struct S { static constexpr int x = 0; };

int main(){
	int b = true;
	int n = b ? S::x : 2;
	std::cout << n;
}
