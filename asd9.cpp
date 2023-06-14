#include <iostream>
#include <memory> // and others
		  //

int a = 5;
int& foo(int& a) {
	return a;
}
using namespace std;

int main(){
	int* xx = ::new int[]{3,4,2};
	delete[] xx;
	std::cout << foo(a);
}

